class Notifier < ActionMailer::Base
  def activation_instructions(user)
    subject     "Activation Instructions"
    from        "trev@mettafilter.com"
    recipients  user.email
    sent_on     Time.now
    body        :account_activation_url => activate_url(user.perishable_token)
  end
  
  def welcome(user)
    subject     "Welcome to the site!"
    from        "trev@mettafilter.com"
    recipients  user.email
    sent_on     Time.now
    body        :root_url => root_url
  end
  
end
