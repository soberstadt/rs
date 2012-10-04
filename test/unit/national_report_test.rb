require File.dirname(__FILE__) + '/../test_helper'

class NationalReportTest < Test::Unit::TestCase
  fixtures :fsk_allocations, :fsk_orders, :ministry_regionalteam

  def test_national_report
    report = NationalReport.new
    assert report.regional_reports.size > 0
    # assert_equal report.totals["impact_allotment"], 200
  end
end
