class WelcomeController < ApplicationController
  def index
    require 'koala'
    @oauth = Koala::Facebook::OAuth.new(getconfig('fb_app_id'), getconfig('fb_app_secret'), "http://localhost:3000/")
    if request.GET['code']
      setup
    end

    if getconfig('fb_user_access_token') != '0' && getconfig('fb_page_access_token') != '0'
      @graph_user = Koala::Facebook::API.new(getconfig('fb_user_access_token'))
      @graph_page = Koala::Facebook::API.new(getconfig('fb_page_access_token'))
      @live_video_result = @graph_page.put_connections(
        getconfig('fb_page_id'),
        "live_videos",
      #  #:content_tags => '',
        :description => 'This is Davids Long desc of this video!!',
      #  :is_audio_only => 0,
      #  #:planned_start_time => "",
      #  #:privacy => '',
        :save_vod => true,
      #  #:schedule_custom_profile_image => '',
        :status => 'LIVE_NOW',
      #  :stop_on_delete_stream => 'true',
        :stream_type => 'REGULAR',
        :title => 'Davids Test Video'
      )
      @output = @live_video_result['stream_url']
    else
      @output = "<a href='#{@oauth.url_for_oauth_code(:permissions => "pages_show_list,pages_manage_cta,read_insights,manage_pages,publish_pages,publish_actions,business_management,user_managed_groups,user_videos,user_events")}''>FB Auth 1</a>"
      @output = @output.html_safe
    end
  end

  def setup
    setconfig('fb_user_access_token',@oauth.get_access_token(request.GET['code']))
    @graph_user = Koala::Facebook::API.new(getconfig('fb_user_access_token'))
    setconfig('fb_page_access_token',@graph_user.get_page_access_token(getconfig('fb_page_id')))
    redirect_to "http://localhost:3000/"
  end

  def getconfig(configname)
    thisconfig = Config.where(:name => configname)
    if thisconfig.count == 1
      return thisconfig.first.value
    else
      return false
    end
  end

  def setconfig(configname,configvalue)
    if getconfig configname == 0
      Config.new(:name => configname, :value=> configvalue).save
    else
      thisconfig = Config.where(:name => configname)
      thisconfig.update(value: configvalue)
    end
  end
end
