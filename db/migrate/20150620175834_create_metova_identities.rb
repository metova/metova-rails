class CreateMetovaIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :metova_identities do |t|
      t.string :uid
      t.string :provider
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
