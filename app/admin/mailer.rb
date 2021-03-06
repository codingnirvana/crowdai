ActiveAdmin.register Mailer do
  #config.filters = false
  permit_params :mailer, :paused


  sidebar "Links", only: [:show, :edit] do
    ul do
      li link_to "Emails", admin_mailer_emails_path(mailer)
    end
  end

  controller do
  end

  filter :mailer_classname
  filter :paused

  index do
    selectable_column
    column :mailer_classname
    column :paused
    actions
  end

end
