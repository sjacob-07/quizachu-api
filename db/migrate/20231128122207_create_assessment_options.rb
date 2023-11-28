class CreateAssessmentOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :assessment_options do |t|
      t.references :assessment_question, null: false, foreign_key: true
      t.string :option
      t.string :option_attachment
      t.string :option_attachment_caption
      t.integer :option_seq
      t.boolean :is_correct_option, default: false
      t.string :option_type
      t.boolean :is_active, default: true
      t.datetime :deleted_at

      t.boolean :model_generated
      t.datetime :generated_at

      t.timestamps
    end
  end
end
