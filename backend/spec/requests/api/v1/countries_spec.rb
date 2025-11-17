require "rails_helper"

RSpec.describe "Api::V1::Countries" do
  describe "GET /api/v1/countries/random" do

    context "正常系" do
      context "国データが複数存在する場合" do
        # 複数のデータを作成して「ランダム性」をテストできるようにする
        let!(:country_a) { Country.create!(name: "日本",
        flag_url: "jp.png",
        hint_1: "ヒントA1",
        hint_2: "ヒントA2",
        hint_3: "ヒントA3",
        hint_4: "ヒントA4") }

        let!(:country_b) { Country.create!(name: "フランス",
        flag_url: "fr.png",
        hint_1: "ヒントB1",
        hint_2: "ヒントB2",
        hint_3: "ヒントB3",
        hint_4: "ヒントB4") }

        # 検証に使う「存在するIDのリスト」を用意
        let(:country_ids) { [country_a.id, country_b.id] }

        it "存在する国のいずれかのデータを、正しいJSON形式で返す" do
          # APIリクエストを送信した時点でresponseオブジェクトが定義される
          get "/api/v1/countries/random"

          expect(response).to have_http_status(:ok)

          json = response.parsed_body

          # 1. ランダム性の検証（IDが、存在するIDリストのどれかであること）
          expect(json).to have_key("quiz_id")
          expect(country_ids).to include(json["quiz_id"]) # eq ではなく include で検証

          # 2. 形式の検証（キーが存在し、ヒントが配列であること）
          expect(json).to have_key("flag_url")
          expect(json).to have_key("hints")
          expect(json["hints"]).to be_an(Array)

          # 3. 内容の検証（返ってきたIDの国情報と、レスポンスの内容が一致するか）
          #    .compact はコントローラーの実装に合わせる（nilのヒントを除外）
          returned_country = Country.find(json["quiz_id"])

          expect(json["flag_url"]).to eq(returned_country.flag_url)
          expect(json["hints"]).to eq(
            [
              returned_country.hint_1,
              returned_country.hint_2,
              returned_country.hint_3,
              returned_country.hint_4
            ].compact # .compact を忘れずに
          )
        end
      end
    end

    context "異常系" do
      context "国データが存在しない場合" do
        # このテストの前にDBを空にする
        before { Country.destroy_all }

        it "404 not_found とエラーメッセージを返す" do
          get "/api/v1/countries/random"

          expect(response).to have_http_status(:not_found) # 404

          json = response.parsed_body
          
          expect(json["error"]).to eq("No countries available.")
        end
      end
    end
  end
end
