require "rails_helper"

feature 'Manage todos on the list', js: true do
  def create_todo(title)
    visit root_path
    fill_in "todo_title", with: "Catch the capibara things."
    page.execute_script("$('form#new_todo').submit()")
  end

  scenario "We can create new tasks" do
      create_todo(title)
      expect(page).to have_content("Catch the capibara things.")
    end

  scenario 'The counter updates when creating new tasks' do
    create_todo(title)
    expect( page.find(:css, 'span#todo-count').text ).to eq "1"
  end

  scenario "The completed counter updates when completing tasks" do
    create_todo(title)
    expect( page.find(:css, 'span#completed-count').text ).to eq "0"
    check "todo-1"
    expect( page.find(:css, 'span#todo-count').text ).to eq "0"
    expect( page.find(:css, 'span#completed-count').text ).to eq "1"
  end

  scenario "We can create 3 tasks with working counters" do
    create_todo(title)
    create_todo(title)
    create_todo(title)
    expect( page.find(:css, 'span#completed-count').text ).to eq "0"
    check "todo-1"
    check "todo-2"
    expect( page.find(:css, 'span#todo-count').text ).to eq "1"
    expect( page.find(:css, 'span#completed-count').text ).to eq "2"
    expect( page.find(:css, 'span#total-count').text ).to eq "3"
  end

  scenario "We can clean up completed tasks and update the counters" do
    create_todo(title)
    check "todo-1"
    expect( page.find(:css, 'span#total-count').text ).to eq "1"
    expect( page.find(:css, 'span#completed-count').text ).to eq "1"
    click_link("clean-up")
    expect( page.find(:css, 'span#total-count').text ).to eq "0"
    expect( page.find(:css, 'span#completed-count').text ).to eq "0"
  end

  scenario "We have no ramining completeded task in list after cleaning up" do
    create_todo(title)
    check "todo-1"
    click_link("clean-up")
    expect(page).not_to have_content("todo_title")
  end
end
