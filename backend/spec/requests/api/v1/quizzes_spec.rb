require "rails_helper"

RSpec.describe "Api::V1::Quizzes" do
  describe "POST /api/v1/quizzes/check クイズ回答チェック" do
    let!(:country) do
      Country.create!(
        name: "日本",
        reading: "にほん",
        hint_1: "世界で62位の面積",
        hint_2: "通貨: 円 (JPY)",
        hint_3: "首都: 東京",
        hint_4: "寿司とアニメで有名",
        flag_url: "https://flagcdn.com/w320/jp.png"
      )
    end

    # RSpec/ContextWording: context は "when/with/without" で始める
    context "when answer is correct" do
      it "ひらがなの回答で正解判定される" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id,
          answer: "にほん"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("日本")
      end

      it "カタカナの回答で正解判定される" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id,
          answer: "ニホン"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("日本")
      end

      it "回答の前後の空白を無視して判定する" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id,
          answer: "  にほん  "
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("日本")
      end
    end

    context "when answer is incorrect" do
      it "誤った回答で不正解判定される" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id,
          answer: "ちゅうごく"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be false
        expect(json["correct_answer"]).to eq("日本")
      end
    end

    context "when quiz_id is invalid" do
      it "無効なquiz_idでエラーメッセージを返す" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: 99_999,
          answer: "日本"
        }

        expect(response).to have_http_status(:bad_request)

        json = response.parsed_body
        expect(json["error"]).to eq("Invalid quiz_id")
      end
    end

    context "when quiz_id parameter is missing" do
      it "quiz_idパラメータ未指定でエラーメッセージを返す" do
        post "/api/v1/quizzes/check", params: {
          answer: "日本"
        }

        expect(response).to have_http_status(:bad_request)

        json = response.parsed_body
        expect(json["error"]).to eq("Invalid quiz_id")
      end
    end

    context "when answer parameter is missing" do
      it "回答パラメータ未指定で不正解判定される" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: country.id
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be false
        expect(json["correct_answer"]).to eq("日本")
      end
    end

    context "when multiple countries exist" do
      let!(:germany) do
        Country.create!(
          name: "ドイツ",
          reading: "どいつ",
          hint_1: "世界で63位の面積",
          hint_2: "通貨: ユーロ (EUR)",
          hint_3: "首都: ベルリン",
          hint_4: "ビールとソーセージ",
          flag_url: "https://flagcdn.com/w320/de.png"
        )
      end

      it "複数の国が存在する場合もひらがなで正しく判定する" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: germany.id,
          answer: "どいつ"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("ドイツ")
      end

      it "複数の国が存在する場合もカタカナで正しく判定する" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: germany.id,
          answer: "ドイツ"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be true
        expect(json["correct_answer"]).to eq("ドイツ")
      end

      it "異なる国の名前を回答すると不正解判定される" do
        post "/api/v1/quizzes/check", params: {
          quiz_id: germany.id,
          answer: "にほん"
        }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body
        expect(json["correct"]).to be false
        expect(json["correct_answer"]).to eq("ドイツ")
      end
    end
  end
end
