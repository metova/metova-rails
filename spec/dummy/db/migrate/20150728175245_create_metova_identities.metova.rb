# This migration comes from metova (originally 20150620175834)
class CreateMetovaIdentities < ActiveRecord::Migration
  def change
    create_table :metova_identities do |t|
      t.string :uid
      t.string :provider
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
