/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Logger } from './Logger';
import { StyleConstants } from '../constants/StyleConstants';
import { Opt } from '../viewmodel/CommodityModel';
import { ProductSpecification, SkuStock } from '../viewmodel/ProductModel';
import { ip } from './Request';


const MiniIO_URL: string = `http://${ip}:9000`
/**
 * Format date.
 * @param timestamp time
 * @param format = "yyyy-mm-dd"
 * @returns res
 */
export function formatDate(timestamp: number, format = 'yyyy-mm-dd') {
  let res = "";
  try {
    const date = new Date(timestamp);
    const opt: Opt = {
      yy: date.getFullYear().toString(),
      mm: (date.getMonth() + 1).toString(),
      dd: date.getDate().toString(),
      HH: date.getHours().toString(),
      MM: date.getMinutes().toString(),
      SS: date.getSeconds().toString(),
    };

    const regKeys: string[] = ['y+', 'm+', 'd+', 'H+', 'M+', 'S+'];
    for (let i = 0; i < regKeys.length; i++) {
      const regKey = regKeys[i];
      const reg = new RegExp(regKey);
      let ret = reg.exec(format);
      if (ret) {
        switch (regKey) {
          case 'y+':
            format = format.replace(reg, ret.length === 1 ? opt.yy : opt.yy.padStart(ret.length, "0"));
          case 'm+':
            format = format.replace(reg, ret.length === 1 ? opt.mm : opt.mm.padStart(ret.length, "0"));
          case 'd+':
            format = format.replace(reg, ret.length === 1 ? opt.dd : opt.dd.padStart(ret.length, "0"));
          case 'H+':
            format = format.replace(reg, ret.length === 1 ? opt.HH : opt.HH.padStart(ret.length, "0"));
          case 'M+':
            format = format.replace(reg, ret.length === 1 ? opt.MM : opt.MM.padStart(ret.length, "0"));
          case 'S+':
            format = format.replace(reg, ret.length === 1 ? opt.SS : opt.SS.padStart(ret.length, "0"));
        }
      }
    }
    res = format;
  } catch (error) {
    Logger.error("ERROR formatDate" + error);
  }
  return res;
}


export function formatLocalhost(url: string, format: string = MiniIO_URL): string {
  const target = 'http://localhost:9000'
  if (url?.includes(target)) {
    return url.replace(target, format)
  }
  return url
}

export function formatRichHTMLText(richText: string, format: string = MiniIO_URL): string {
  const target = 'http://localhost:9000'
  while (richText?.includes(target)) {
    richText = richText.replace(target, format)
  }
  return richText
}
/**
 * Get id.
 *
 * @returns id
 */
export function getID() {
  const date = Date.now()
  const arr = `${date}`.split('')
  arr.sort(() => (Math.random() - StyleConstants.HALF_ONE) > 0 ? 1 : StyleConstants.MINUS_ONE)

  return arr.join('')
}

/**
 * 获取sku
 * @param skuStockList
 * @param specSelected
 */
export function getSkuStock(skuStockList: SkuStock[], specSelected: ProductSpecification[]) {
  const spec = JSON.stringify(specSelected)
  const target = skuStockList.find((skuStock) => skuStock.spData === spec);
  return target ? target : null
}