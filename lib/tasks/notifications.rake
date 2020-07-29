namespace :notifications do

  desc 'Send Ios development notification test'
  task :send_ios_test => :environment do
    anp = AppleNotificationPublisher.new
    anp.pem = "/Users/manoelquirino/Desktop/desktop/Certificados-com.pointsrocket.WebView.debug.pem"
    anp.device_token = "10D753013B23F564A20E399D8917B8352A4F16DA67C95EE265BE812ECC4FE5E3"

    # ja faz login no biolike
    url = "http://prck.co/jCJ"
    anp.message = url

    if url.present?
      anp.other = {
        url: url
      }
    end

    anp.badge = 2
    anp.sound = "default"
    ap anp.publish
  end

  desc 'Send android development notification test'
  task :send_android_test => :environment do
    anp = AndroidNotificationPublisher.new
    anp.key = "AAAA41BcSxI:APA91bGM6cj9wO5ObCxGuFiaXCF8VrHf3ZbcNO1xNjG1dyLqPI0vDiJl5-pB5gGUuEjx2kXyckG3_ryDKaPVCXGbKKAUM5fOtiZZ9HoljtWp08dhV2zSFVnQbiODpJBsO-Y88QaJfvhM"
    anp.message = "Teste"
    anp.devices_ids = [
      "fMBwUe6KasY:APA91bFp-MO8GZ3sMvpTYufrqApzVdHIl4KzgFZq4s1uOvzMLpi06rpoKjDngm0_QX13iO0YsqzvJp0QVO4n9s2y733vglt5q0qJ0vyCtufEol9Tr1qV1_G_XHtMEOx-H8HjioZfRI1H"
    ]
    anp.data = {
      url: "https://www.pointsrocket.com/"
    }
    anp.publish
  end

end
