When /^I do a capybara search that triggers the nested synchronize bug/ do
  visit "/test/for_reproducing_capybara_synchronize_bug"
  begin
    # No problem (wait time of 40)
    within ".some_div_that_doesnt_exist" do
      select('2000', from: "select_that_doesnt_exist")
    end
  rescue Capybara::ElementNotFound; end

  STDOUT.puts '='*100
  # Hangs (Exponential wait time (40*40))
  within ".some_div_that_really_exists" do
    select('2000', from: "select_that_doesnt_exist")
  end
end
