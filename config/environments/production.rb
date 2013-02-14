Kanban::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false


  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false
  # Generate digests for assets URLs
  config.assets.digest = true
  # Compress JavaScripts and CSS
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  # config.assets.js_compressor = Uglifier.new(:copyright => false)
  config.assets.initialize_on_precompile = false
  config.assets.precompile += ['accounts.js', 'projects.js', 'project.js']


  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      bucket:            'iulian_s4s_production',
      access_key_id:     'AKIAJV37HG7SSXR3PAPQ',
      secret_access_key: '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'
    }
  }

end
