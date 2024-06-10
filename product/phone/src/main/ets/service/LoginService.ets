import { Request, Preferences } from '@ohos/common'
import router from '@ohos.router'
import { PageConstants } from '../constants/PageConstants'
import promptAction from '@ohos.promptAction'

class LoginService {

  public reg_tel = /^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$/

  async register(username: string, password: string, telephone: string, authCode: string): Promise<boolean> {
    if (username.length && password.length && telephone.length && authCode.length) {
      const res = await Request.post(`/sso/register`,
        `username=${username}&password=${password}&telephone=${telephone}&authCode=${authCode}`
      )
      if (res.code === 200 && res.message === '注册成功') {
        return true
      } else {
        promptAction.showToast({ message: res.message })
      }
      return false
    }
  }

  async login(username: string, password: string): Promise<boolean> {
    if (username.length && password.length) {
      const res = await Request.post(`/sso/login?username=${username}&password=${password}`)
      if (typeof res.data === 'object' && res.data !== null) {
        const token = res.data.tokenHead + res.data.token
        await Preferences.put('token', token)
        return true
      } else {
        promptAction.showToast({ message: res.message })
        return false
      }
    }
  }

  async logout() {
    await Preferences.delete('token')
    await Preferences.delete('userInfo')
    router.replaceUrl({ url: PageConstants.LOGIN_PAGE_URL })
  }

  async getAuthCode(telephone: string): Promise<string> {
    if (this.reg_tel.test(telephone)) {
      return Request.get('/sso/getAuthCode', { params: { telephone }}).then(res => res.data)
    }
  }

  async getUserInfo() {
   return await Request.get('/sso/info')
  }
}

export const loginService = new LoginService()