import dataPreferences from '@ohos.data.preferences'
import { GlobalContext } from './GlobalContext'
import { Logger } from './Logger'

const LOG = 'PreferencesUtils-PUT'
// 默认文件名(数据库表名)，可以在构造函数进行修改
const PREFERENCES_NAME = 'store'
const KEY_PREFERENCES = 'preferences'
type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean>

export class PreferencesUtils {
  // preferences的文件名-数据库表名
  private preferencesName: string = PREFERENCES_NAME
  // 用于获取preferences实例的key值，保存到单例中
  private keyPreferences: string = KEY_PREFERENCES

  constructor(name: string = PREFERENCES_NAME, key: string = KEY_PREFERENCES) {
    this.preferencesName = name
    this.keyPreferences = key
  }

  /**
   * 创建首选项实例
   * @param context: 应用上下文
   * @param preferencesName: 数据库表名
   * @returns
   */
  createPreferences(context): Promise<dataPreferences.Preferences> {
    let preferences = dataPreferences.getPreferences(context, this.preferencesName)
    GlobalContext.getContext().setObject(this.keyPreferences, preferences)
    return
  }

  /**
   * 获取首选项实例
   * @returns
   */
  getPreferences(): Promise<dataPreferences.Preferences> {
    return GlobalContext.getContext().getObject(this.keyPreferences) as Promise<dataPreferences.Preferences>
  }

  /**
   * 获取数据
   * @param key: 读取key值
   * @param def: 默认返回值
   * @returns
   */
  async get(key: string, def?: ValueType): Promise<ValueType> {
    return (await this.getPreferences()).get(key, def)
  }

  // 获取全部数据
  async getAll(): Promise<Object> {
    let preferences = await this.getPreferences()
    return preferences.getAll()
  }

  /**
   * 插入数据
   * @param key: 存入key值
   * @param value: 存储数据
   * @returns
   */
  async put(key: string, value: ValueType): Promise<void> {
    let promise = await this.getPreferences().then(async preferences => {
      // 插入数据
      await preferences.put(key, value)
      console.log('插入', key, value)
      // 写入文件
      await preferences.flush()
    }).catch(error => {
      Logger.error(LOG, `code:${error.code}, message:${error.message}`)
    })
    return promise
  }

  /**
   * 删除数据
   * @param key: 删除key的value值
   * @returns
   */
  async delete(key: string): Promise<void> {
    return (await this.getPreferences()).delete(key).finally(async () => {
      (await this.getPreferences()).flush()
    })
  }

  // 清空数据
  async clear(): Promise<void> {
    return (await this.getPreferences()).clear().finally(async () => {
      (await this.getPreferences()).flush()
    })
  }
}

export const Preferences = new PreferencesUtils()