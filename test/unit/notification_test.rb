require 'test_helper'

class NotificationTest < ActionMailer::TestCase
  test "welcome" do
    @expected.subject = 'Notification#welcome'
    @expected.body    = read_fixture('welcome')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notification.create_welcome(@expected.date).encoded
  end

end
