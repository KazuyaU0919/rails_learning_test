class AddAnswerCodeToPreCodesAndDropHintCode < ActiveRecord::Migration[8.0]
  def change
    # answer_code を追加（なければ）
    unless column_exists?(:pre_codes, :answer_code)
      add_column :pre_codes, :answer_code, :text
    end

    # hint_code を削除（あれば）
    if column_exists?(:pre_codes, :hint_code)
      remove_column :pre_codes, :hint_code, :text
    end
  end
end
