require 'spec_helper'

describe "Stock Locations", type: :feature, js: true do
  stub_authorization!

  let!(:country) { create(:country) }
  let!(:state) { create(:state, country: country) }

  before(:each) do
    visit spree.admin_stock_locations_path
  end

  it "can create a new stock location" do
    click_link "New Stock Location"
    fill_in "Name", with: "London"
    targetted_select2_search state.name, from: "#s2id_stock_location_state_id"
    click_button "Create"

    expect(Spree::StockLocation.last.state.name).to eq(state.name)
    expect(Spree::StockLocation.last.name).to eq("London")
  end

  it "can delete an existing stock location" do
    location = create(:stock_location)
    visit current_path

    expect(find('#listing_stock_locations')).to have_content("NY Warehouse")
    accept_alert do
      click_icon :delete
    end
    # Wait for API request to complete.
    wait_for_ajax
    visit current_path
    expect(page).to have_content("No Stock Locations found")
  end

  it "can update an existing stock location" do
    create(:stock_location)
    visit current_path

    expect(page).to have_content("NY Warehouse")

    click_icon :edit
    fill_in "Name", with: "London"
    click_button "Update"

    expect(page).to have_content("successfully updated")
    expect(page).to have_content("London")
  end
end
