import axios, { CreateAxiosDefaults, InternalAxiosRequestConfig } from '@ohos/axios'
import hilog from '@ohos.hilog'
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import { Logger } from './Logger'
import { Preferences } from './Preferences'

export interface BaseResponse<T> {
  data: T;
  message: string;
  code: number
}

const baseConfig: CreateAxiosDefaults = {
  baseURL: 'http://192.168.64.80:8085',  //'https://portal-api.macrozheng.com',
  timeout: 5000
}

const axiosInstance = axios.create(baseConfig)

axiosInstance.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  await Preferences.get('token', false)
    .then((token) => {
      if (token && typeof token === 'string') {
        config.headers.setAuthorization(token)
      }
    })
    .catch((error) => {
      Logger.error('token:undefined', error)
    })
  Logger.debug(JSON.stringify(config))
  return config
}, (error) => {
  hilog.error(0xFFFF, 'fail:request', error)
  return Promise.reject(error)
})

axiosInstance.interceptors.response.use((response) => {
  const res = response.data
  if (res.code !== 200) {
    promptAction.showToast({
      message: res.message,
      duration: 1500
    })
  }

  if (res.code === 401) {
    promptAction.showDialog({
      title: '提示',
      message: '你已经被登出，可以取消继续留在该页面，或者重新登录',
      buttons: [
        {
          text: '重新登录',
          color: '#00000'
        },
        {
          text: '取消',
          color: '#00000'
        }
      ]
    })
      .then(res => {
        if (res.index === 0) {
          router.replaceUrl({
            url: 'pages/LoginPage'
          })
        }
      })

    return Promise.reject(response)
  }
  return response
}, (error) => {
  Logger.error('error:response', error)
  promptAction.showToast({
    message: '网络发生异常，详情查看日志',
    duration: 1500
  })
  return Promise.reject(error)
})

export const Request = {
  get: (url, config?) => axiosInstance.get(url, config).then(res => res.data),
  post: (url, data?, config?) => axiosInstance.post(url, data, config).then(res => res.data),
  originalPost: axiosInstance.post
}