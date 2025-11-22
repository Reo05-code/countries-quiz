'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { fetchUserFlags } from '@/lib/api/collection'
import type { UserFlag } from '@/types/collection'

export default function CollectionPage() {
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [flags, setFlags] = useState<UserFlag[]>([])

  useEffect(() => {
    const loadFlags = async () => {
      try {
        const data = await fetchUserFlags()
        setFlags(data)
      } catch (err) {
        const errorMessage = err instanceof Error ? err.message : 'データの取得に失敗しました'
        setError(errorMessage)
      } finally {
        setLoading(false)
      }
    }
    loadFlags()
  }, [])

  return (
    <main className="min-h-screen bg-gradient-to-br from-gray-100 to-gray-200 p-4">
      <div className="max-w-5xl mx-auto">
        <div className="bg-white rounded-2xl shadow-xl p-8">
          <div className="flex justify-between items-center mb-8">
            <h1 className="text-3xl font-bold text-gray-800">
              🏆 国旗コレクション
            </h1>
            <Link
              href="/quiz"
              className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition"
            >
              クイズに戻る
            </Link>
          </div>

          {loading ? (
            <div className="text-center py-12">
              <p className="text-gray-500 text-xl">読み込み中...</p>
            </div>
          ) : error ? (
            <div className="text-center py-12">
              <p className="text-red-500">{error}</p>
            </div>
          ) : flags.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-gray-500 text-xl mb-4">まだ国旗を獲得していません</p>
              <Link
                href="/quiz"
                className="text-blue-600 hover:underline"
              >
                クイズに挑戦して国旗を集めよう！
              </Link>
            </div>
          ) : (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6">
              {flags.map((flag) => (
                <div key={flag.id} className="flex flex-col items-center p-4 bg-gray-50 rounded-xl border border-gray-200 hover:shadow-md transition">
                  <div className="w-full aspect-video relative mb-3 shadow-sm">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img
                      src={flag.flagUrl}
                      alt={flag.name}
                      className="w-full h-full object-cover rounded-md"
                    />
                  </div>
                  <p className="font-bold text-gray-700 text-center">{flag.name}</p>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </main>
  )
}
