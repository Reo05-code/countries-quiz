'use client'

export default function QuizPage() {
  const handleStartQuiz = () => {
    console.log('クイズ開始ボタンが押されました')
  }

  return (
    <main className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 p-4">
      <div className="max-w-2xl w-full">
        <div className="bg-white rounded-2xl shadow-xl p-8">
          {/* タイトル */}
          <div className="text-center mb-8">
            <h1 className="text-4xl font-bold text-gray-800 mb-2">
              🌍 国旗クイズ
            </h1>
            <p className="text-gray-600">
              国旗を見て国名を当てよう！
            </p>
          </div>

          {/* 開始ボタン */}
          <div className="text-center">
            <button
              onClick={handleStartQuiz}
              className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 px-8 rounded-lg text-xl shadow-lg transition"
            >
              クイズを開始
            </button>
          </div>
        </div>
      </div>
    </main>
  )
}
