class MassNotifier < ActionMailer::Base

  def mass_mail(email,properties_ids)
    @properties = Property.find(:all)
    @from = ("fred@fred.local")
    @recipients = email
    @sent_on = Time.now
    @subject = 'Hello there'
    @content_type = "text/html" # Important, must be html
    @body["properties"]= @properties
  end

end
