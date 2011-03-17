mailchimp_ses
=============

This library implements a couple of methods in the new MailChimp SES API.

Setup
-----
Add to your Gemfile:

    gem 'mailchimp_ses'

Configure your API key somewhere (in Rails, create `config/initializer/mailchimp_ses.rb`):

    MailchimpSes.api_key = 'myapikey-us1'

send_email
----------

Any missing required fields will raise ArgumentError from this method call.

Usage example:

    MailchimpSes.send_email(
      :message => {
        :subject => 'Welcome to our website!',
        :html => '<html>Welcome to our site.</html>',
        :text => 'Welcome to our website.',
        :from_name => 'David Balatero',
        :from_email => 'david@balatero.com',
        :reply_to => 'david@alias.com',
        :to_email => ['john@smith.com'],
        :to_name => ['John Smith']
      },
      :tags => ['welcome_message', 'new_user'],
      :track_opens => true,
      :track_clicks => true
    )

Returns the parsed JSON response from MailChimp. Sample response:

    { 
      "msg" => nil,
      "aws_code" => nil,
      "status" => "sent",
      "message_id" => "6710077a-372b-11e0-blah-blah-blah"
    }
    
verify_email_address
--------------------

A quick method to send an email verification message out. Useful for testing.

    result = MailchimpSes.verify_email_address('foo@bar.com')
    puts result.to_s     # => "true"

Contributing to mailchimp_ses
-----------------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2011 David Balatero. See LICENSE.txt for
further details.

