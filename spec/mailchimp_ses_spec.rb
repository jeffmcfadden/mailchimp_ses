require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MailchimpSes" do
  before(:each) do
    # disabled in production.
    MailchimpSes.api_key = "test-us1"

    @valid_params = {
      :message => {
        :subject => 'Welcome to our website!',
        :html => '<html>Welcome to our site.</html>',
        :text => 'Welcome to our website.',
        :from_name => 'David Balatero',
        :from_email => 'david@mediapiston.com',
        :to_email => ['dbalatero@gmail.com',],
        :to_name => ['David Balatero']
      },
      :tags => ['fun', 'message', 'unique'],
      :track_opens => true,
      :track_clicks => true
    }
  end

  describe "#send_email" do
    describe "error checking" do
      it "should raise error w/ no api key" do
        MailchimpSes.api_key = nil
        lambda {
          MailchimpSes.send_email(@valid_params)
        }.should raise_error(ArgumentError)
      end

      [:track_opens, :track_clicks].each do |field|
        it "should require #{field}" do
          @valid_params.delete(field)
          lambda {
            MailchimpSes.send_email(@valid_params)
          }.should raise_error(ArgumentError)
        end
      end

      [:html, :subject, :from_name, :from_email, :to_email].each do |field|
        it "should require message #{field}" do
          @valid_params[:message].delete(field)
          lambda {
            MailchimpSes.send_email(@valid_params)
          }.should raise_error(ArgumentError)
        end
      end

      it "should not allow to_email and to_name to be diff length" do
        @valid_params[:message][:to_email] = ['fds@fds.com', 'a@b.com']
        @valid_params[:message][:to_name] = ['My Friend Fds']

        lambda {
          MailchimpSes.send_email(@valid_params)
        }.should raise_error(ArgumentError)
      end
    end

    describe "real requests" do
      use_vcr_cassette 'send_email', :record => :new_episodes

      it "should return a success or failure" do
        result = MailchimpSes.send_email(@valid_params)
        result['status'].should == 'sent'
        result['message_id'].should_not be_nil
      end
    end
  end
end
