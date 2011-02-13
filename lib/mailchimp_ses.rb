require 'monster_mash'
require 'json'

class MailchimpSes < MonsterMash::Base
  @api_key = nil

  defaults do
    params :apikey => MailchimpSes.api_key
  end

  class << self
    attr_accessor :api_key
  end

  post(:verify_email_address) do |email|
    check_api_key!
    uri "http://#{datacenter}.sts.mailchimp.com/1.0/VerifyEmailAddress"
    params :email => email
    handler do |response|
      true
    end
  end

  post(:send_email) do |options|
    check_api_key!

    uri "http://#{datacenter}.sts.mailchimp.com/1.0/SendEmail"

    # Message params.
    message = {
      :html => extract_param(options[:message], :html),
      :text => options[:message][:text],
      :subject => extract_param(options[:message], :subject),
      :from_name => extract_param(options[:message], :from_name),
      :from_email => extract_param(options[:message], :from_email),
      :to_email => convert_to_hash_array(extract_param(options[:message], :to_email))
    }

    # Pull optional to_name.
    if options[:message].has_key?(:to_name) && !options[:message][:to_name].empty?
      message[:to_name] = convert_to_hash_array(options[:message][:to_name])
    end

    # Check on to_email and to_name length.
    if message.has_key?(:to_email) && message.has_key?(:to_name) &&
        message[:to_email].size != message[:to_name].size
      raise ArgumentError, "to_email and to_name need the same number of values"
    end

    # Handle tags.
    tags = nil
    if options[:tags] && options[:tags].size > 0
      tags = convert_to_hash_array(options[:tags])
    end

    params :message => message,
           :track_opens => extract_param(options, :track_opens).to_s,
           :track_clicks => extract_param(options, :track_clicks).to_s,
           :tags => tags
            
    handler do |response|
      json = JSON.parse(response.body)
    end
  end

private

  def self.check_api_key!
    if self.api_key.nil?
      raise ArgumentError, "Set MailchimpSes.api_key in your config."
    end
  end

  def self.convert_to_hash_array(value)
    # Turn strings into 1-element arrays.
    value = value.is_a?(Array) ? value : [value]

    hash = {}
    value.each_with_index { |val, i| hash[i] = val }
    hash
  end

  def self.extract_param(hash, key)
    if !hash.has_key?(key) || (hash[key].respond_to?(:empty?) && hash[key].empty?)
      raise ArgumentError, "missing required #{key}"
    end
    hash[key]
  end

  def self.datacenter
    api_key.split(/-/).last
  end
end
