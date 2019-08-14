class LinebotController < ApplicationController
    require 'line/bot'  # gem 'line-bot-api'の呼び出し
  
    # callbackアクションのCSRFトークン認証を無効
    protect_from_forgery :except => [:callback]
  
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = "07531d670c2ca365794a2c989f7a56b4"
        config.channel_token = "7iS7h2BvEnPsZYBUe+0nB4L5jPmgPc/XP4dGJ8gPwh0rkMC01K/P7EE9eKHsrhI0NqTsuITHGmdXQ/PsaHqDiB1pHPA6ivNLOozl2MIdJqSwqEQ4HIdb77pyw5JDwtDbvNKZzqdkzh1AIrZTHvGcJgdB04t89/1O/w1cDnyilFU="
      }
    end
  
    def callback
      body = request.body.read
  
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        head :bad_request
      end
  
      events = client.parse_events_from(body)
      
      events.each { |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text
            message = {
              type: 'text',
              text: "いいよ"
            }
            client.reply_message(event['replyToken'], message)
          end
        end
      }
  
      head :ok
    end
  end
