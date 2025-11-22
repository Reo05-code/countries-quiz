import camelcaseKeys from 'camelcase-keys'
import { apiClient } from './client'
import type { UserFlag } from '@/types/collection'

/**
 * ユーザーの獲得した国旗一覧を取得
 */
export async function fetchUserFlags(): Promise<UserFlag[]> {
  const response = await apiClient.get('/api/v1/user_flags')
  return camelcaseKeys(response.data, { deep: true })
}
