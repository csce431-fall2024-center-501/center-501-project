class CreateSponsorships < ActiveRecord::Migration[7.0]
  def change
    create_table :sponsorships do |t|
      t.string :sponsorName
      t.string :sponsorLeadName
      t.string :sponsorPhone
      t.string :sponsorEmail
      t.decimal :sponsorDonation
      t.date :sponsorEndOfContract

      t.timestamps
    end
  end
end
