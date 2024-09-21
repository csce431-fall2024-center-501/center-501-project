class RenameCamelCaseColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :sponsorships, :sponsorName, :sponsor_name
    rename_column :sponsorships, :sponsorLeadName, :sponsor_lead_name
    rename_column :sponsorships, :sponsorPhone, :sponsor_phone
    rename_column :sponsorships, :sponsorEmail, :sponsor_email
    rename_column :sponsorships, :sponsorDonation, :sponsor_donation
    rename_column :sponsorships, :sponsorEndOfContract, :sponsor_end_of_contract
  end
end
