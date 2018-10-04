class V1::UserController < ApplicationController
  include UserHelper

  def index
    current_user = checkUser(request)
    unless current_user.nil?
      if !params['user']['email'].nil?
        @user = User.where(email: params['user']['email']).first
        if !@user.nil?
          @firend = Friend.check_friend(current_user.id, @user.id).first
        end
      elsif !params['user']['name'].nil?
        @user = User.where(name: params['user']['name']).first
        if !@user.nil?
          @firend = Friend.check_friend(current_user.id, @user.id).first
        end
      else
        @user = nil
      end
      if @user.nil?
        render json: {
            code: 404, message: ["Not found user."]
        }, status: 404
      end
    else
      render json: {
          code: 401, message: ["Unauthorized auth_token."]
      }, status: 401
    end
  end

  def fcm_token
    current_user = checkUser(request)
    unless current_user.nil?
      fcm_token = params['user']['fcm_token']
      if !fcm_token.nil?
        current_user.fcm_token = fcm_token
        current_user.save
        render json: {
            code: 200, message: ["Complete!"]
        }, status: 200
      else
        render json: {
            code: 400, message: ["fcm token is null."]
        }, status: 400
      end
    else
      render json: {
          code: 401, message: ["Unauthorized auth_token."]
      }, status: 401
    end
  end

end
