module Nnnnext::Helpers
  def user
    @user ||= (@state[:user_id] && Nnnnext::Models::User.find(@state[:user_id]))
  end

  def json(obj)
    @headers["content-type"] = "application/json; charset=utf-8"
    obj.to_json
  end

  def logger
    defined?(LOGGER) ? LOGGER : STDOUT
  end

  def js_includes
    if ENV["CONCATENATE_JS"] == "true"
      ["/all.js?#{cachebuster}"]
    else
      js_files
    end
  end

  def js_files
    js = %w(jquery
            jquery.insertAt
            json2
            ontap
            underscore
            backbone
            backbone.localStorage
            iscroll
           ).map { |n| "/js/#{n}.js" }

    js += %w(local-sync
             models/album
             models/user
             collections/album-collection
             collections/filtered-collection
             views/view-shop
             views/view
             views/banner
             views/header
             views/navigation
             views/list-manager
             views/album-view
             views/album-list
             views/album-search-bar
             views/new-album-form
             views/friend-view
             views/friend-list
             views/friend-browser
             views/app-view
             collections
             sync
             main
            ).map { |n| "/coffee/#{n}.js" }
  end

  def cachebuster
    File.mtime(__FILE__).to_i.to_s
  end
end

