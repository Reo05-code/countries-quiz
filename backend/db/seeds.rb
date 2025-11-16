# db/seeds.rb

# トランザクションですべての処理を囲む
ActiveRecord::Base.transaction do
  Rails.logger.debug "データベースをクリーンアップしています..."
  # 依存関係の逆順で削除する
  QuizAttempt.destroy_all
  UserFlag.destroy_all
  User.destroy_all
  Country.destroy_all

  Rails.logger.debug "国データを作成しています..."
  countries_data = [
    {
      name: "日本",
      hint_1: "世界で62位の面積", # 面積ランキング
      hint_2: "通貨: 円 (JPY)",
      hint_3: "首都: 東京",
      hint_4: "寿司とアニメで有名",
      flag_url: "https://flagcdn.com/w320/jp.png"
    },
    {
      name: "アメリカ",
      hint_1: "世界で3位の面積", # 面積ランキング
      hint_2: "通貨: 米ドル (USD)",
      hint_3: "首都: ワシントンD.C.",
      hint_4: "ハリウッドと自由の女神",
      flag_url: "https://flagcdn.com/w320/us.png"
    },
    {
      name: "フランス",
      hint_1: "世界で43位の面積", # 面積ランキング
      hint_2: "通貨: ユーロ (EUR)",
      hint_3: "首都: パリ",
      hint_4: "エッフェル塔とルーヴル美術館",
      flag_url: "https://flagcdn.com/w320/fr.png"
    },
    {
      name: "イタリア",
      hint_1: "世界で72位の面積", # 面積ランキング
      hint_2: "通貨: ユーロ (EUR)",
      hint_3: "首都: ローマ",
      hint_4: "ピザとコロッセオ",
      flag_url: "https://flagcdn.com/w320/it.png"
    },
    {
      name: "ブラジル",
      hint_1: "世界で5位の面積", # 面積ランキング
      hint_2: "通貨: レアル (BRL)",
      hint_3: "首都: ブラジリア",
      hint_4: "サッカーとアマゾン熱帯雨林",
      flag_url: "https://flagcdn.com/w320/br.png"
    },
    {
      name: "オーストラリア",
      hint_1: "世界で6位の面積", # 面積ランキング
      hint_2: "通貨: 豪ドル (AUD)",
      hint_3: "首都: キャンベラ",
      hint_4: "カンガルーとコアラ",
      flag_url: "https://flagcdn.com/w320/au.png"
    },
    {
      name: "イギリス",
      hint_1: "世界で78位の面積", # 面積ランキング
      hint_2: "通貨: ポンド (GBP)",
      hint_3: "首都: ロンドン",
      hint_4: "ビッグベンと紅茶",
      flag_url: "https://flagcdn.com/w320/gb.png"
    },
    {
      name: "ドイツ",
      hint_1: "世界で63位の面積", # 面積ランキング
      hint_2: "通貨: ユーロ (EUR)",
      hint_3: "首都: ベルリン",
      hint_4: "ビールとソーセージ",
      flag_url: "https://flagcdn.com/w320/de.png"
    },
    {
      name: "中国",
      hint_1: "世界で4位の面積", # 面積ランキング
      hint_2: "通貨: 元 (CNY)",
      hint_3: "首都: 北京",
      hint_4: "万里の長城とパンダ",
      flag_url: "https://flagcdn.com/w320/cn.png"
    },
    {
      name: "韓国",
      hint_1: "世界で109位の面積", # 面積ランキング
      hint_2: "通貨: ウォン (KRW)",
      hint_3: "首都: ソウル",
      hint_4: "キムチとK-POP",
      flag_url: "https://flagcdn.com/w320/kr.png"
    }
  ]

  countries_data.each do |country_data|
    Country.create!(country_data)
  end

  Rails.logger.debug { "#{Country.count}個の国を作成しました" }

  Rails.logger.debug "ユーザーを作成しています..."
  users_data = [
    { name: "田中太郎", email: "tanaka@example.com" },
    { name: "佐藤花子", email: "sato@example.com" },
    { name: "鈴木一郎", email: "suzuki@example.com" }
  ]

  users_data.each do |user_data|
    User.create!(user_data)
  end

  Rails.logger.debug { "#{User.count}人のユーザーを作成しました" }

  Rails.logger.debug "クイズの挑戦履歴を作成しています..."

  # .first や .second はID順とは限らないため、名前で明示的に取得する
  user1 = User.find_by!(name: "田中太郎")
  user2 = User.find_by!(name: "佐藤花子")

  country1 = Country.find_by!(name: "日本")
  country2 = Country.find_by!(name: "アメリカ")
  country3 = Country.find_by!(name: "フランス")
  country4 = Country.find_by!(name: "イタリア")

  # ユーザー1の挑戦履歴
  [country1, country2, country3].each_with_index do |country, index|
    QuizAttempt.create!(
      user: user1,
      country: country,
      correct: true,
      hint_level: index + 1
    )
  end

  # ユーザー2の挑戦履歴
  [country1, country4].each do |country|
    QuizAttempt.create!(
      user: user2,
      country: country,
      correct: [true, false].sample,
      hint_level: rand(1..4)
    )
  end
  # ユーザー2が同じ国（日本）で2回挑戦し、2回とも正解した場合のテスト
  # → UserFlagは重複作成されないことを確認
  QuizAttempt.create!(
    user: user2,
    country: country1,
    correct: true, # 2回目も正解
    hint_level: rand(1..4)
  )

  Rails.logger.debug { "#{QuizAttempt.count}件のクイズ挑戦履歴を作成しました" }

  Rails.logger.debug "獲得した国旗を作成しています..."

  # ユーザー1と2を取得
  [user1, user2].each do |user|
    # pluckを使ってIDの配列を直接取得（SQLクエリ1回）
    correct_country_ids = user.quiz_attempts
                              .where(correct: true)
                              .distinct
                              .pluck(:country_id)

    correct_country_ids.each do |country_id|
      UserFlag.find_or_create_by!(user: user, country_id: country_id)
    end
  end

  Rails.logger.debug { "#{UserFlag.count}個の国旗を獲得しました" }
  Rails.logger.debug "サンプルデータの作成が完了しました！"
rescue StandardError => e
  # もし途中でエラーが起きたら
  Rails.logger.debug { "エラーが発生したため、ロールバックしました: #{e.message}" }
  Rails.logger.debug e.backtrace.join("\n")
end

# -----------------------------------------------
# トランザクションの外側で最終結果を表示
# -----------------------------------------------
Rails.logger.debug "=" * 50
Rails.logger.debug "作成されたデータ:"
Rails.logger.debug { "  国: #{Country.count}個" }
Rails.logger.debug { "  ユーザー: #{User.count}人" }
Rails.logger.debug { "  クイズ挑戦: #{QuizAttempt.count}件" }
Rails.logger.debug { "  獲得国旗: #{UserFlag.count}個" }
Rails.logger.debug "=" * 50
