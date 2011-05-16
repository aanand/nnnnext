module Nnnnext::Helpers
  def user
    @user ||= (@request[:auth_token] && Nnnnext::Models::User.where(auth_token: @request[:auth_token]).first)
  end

  def platform
    case @env["HTTP_USER_AGENT"]
    when /\bMobile\b/
      "mobile"
    else
      "desktop"
    end
  end

  def json(obj)
    @headers["content-type"] = "application/json; charset=utf-8"
    obj.to_json
  end

  def logger
    defined?(LOGGER) ? LOGGER : STDOUT
  end

  def css_url
    "/css/#{platform}.css"
  end

  def js_includes
    if Nnnnext.env["CONCATENATE_JS"] == "true"
      ["/all.js"]
    else
      js_files
    end
  end

  def js_files
    js = %w(jquery
            jquery.insertAt
            jquery.sitDownMan
            jquery.tappable
            json2
            underscore
            backbone
            backbone.localStorage
            debug-cache
           ).map { |n| "/js/#{n}.js" }

    js += %w(setup
             models/album
             models/user
             collections/album-collection
             collections/filtered-collection
             views/view-shop
             views/view
             views/list
             views/openable
             views/links
             views/about-page
             views/header
             views/navigation
             views/hint
             views/list-manager
             views/album-view
             views/album-list
             views/album-search-bar
             views/new-album-form
             views/friend-view
             views/friend-list
             views/friend-browser
             views/app-view
             hint
             collections
             sync
             main
            ).map { |n| "/coffee/#{n}.js" }
  end

  def cachebuster
    File.mtime(__FILE__).to_i.to_s
  end

  def google_analytics_account
    Nnnnext.env["GOOGLE_ANALYTICS_ACCOUNT"]
  end
end

