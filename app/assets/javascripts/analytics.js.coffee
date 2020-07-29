#= require ./lib/jquery-ui-1.11.4.custom/jquery-ui
#= require ./lib/datepicker-pt-BR

fbAccessToken = ''

showFollowersEvolution = (fbData, youtubeData, instagramData) ->
  $.plot '#analytics_graph_followers', [
    {
      color: '#3b5998'
      data: fbData
    }
    {
      color: '#e52d27'
      data: youtubeData
    }
    {
      color: '#8a3ab9'
      data: instagramData
    }
  ],
    series:
      lines: show: false
      splines:
        show: true
        tension: 0.01
        lineWidth: 2
        fill: 0
      points:
        show: true
        radius: 4
    grid:
      borderColor: 'rgba(0, 0, 0, 0.05)'
      borderWidth: 1
      hoverable: true
      backgroundColor: 'transparent'
    tooltip: true
    tooltipOpts:
      content: '%y'
      defaultTheme: false
    xaxis:
      tickColor: 'rgba(0, 0, 0, 0.05)'
      mode: 'categories'
    yaxis: tickColor: 'rgba(0, 0, 0, 0.05)'
    shadowSize: 0

showReachEvolution = (fbData, youtubeData, instagramData) ->
  $.plot '#analytics_graph_reach', [
    {
      color: '#3b5998'
      data: fbData
    }
    {
      color: '#e52d27'
      data: youtubeData
    }
    {
      color: '#8a3ab9'
      data: instagramData
    }
  ],
    series:
      lines: show: false
      splines:
        show: true
        tension: 0.01
        lineWidth: 2
        fill: 0
      points:
        show: true
        radius: 4
    grid:
      borderColor: 'rgba(0, 0, 0, 0.05)'
      borderWidth: 1
      hoverable: true
      backgroundColor: 'transparent'
    tooltip: true
    tooltipOpts:
      content: '%y'
      defaultTheme: false
    xaxis:
      tickColor: 'rgba(0, 0, 0, 0.05)'
      mode: 'categories'
    yaxis: tickColor: 'rgba(0, 0, 0, 0.05)'
    shadowSize: 0

showInteractionsEvolution = (fbData, youtubeData, instagramData) ->
  $.plot '#analytics_graph_interactions', [
    {
      color: '#3b5998'
      data: fbData
    }
    {
      color: '#e52d27'
      data: youtubeData
    }
    {
      color: '#8a3ab9'
      data: instagramData
    }
  ],
    series:
      lines: show: false
      splines:
        show: true
        tension: 0.01
        lineWidth: 2
        fill: 0
      points:
        show: true
        radius: 4
    grid:
      borderColor: 'rgba(0, 0, 0, 0.05)'
      borderWidth: 1
      hoverable: true
      backgroundColor: 'transparent'
    tooltip: true
    tooltipOpts:
      content: '%y'
      defaultTheme: false
    xaxis:
      tickColor: 'rgba(0, 0, 0, 0.05)'
      mode: 'categories'
    yaxis: tickColor: 'rgba(0, 0, 0, 0.05)'
    shadowSize: 0

labelFormatter = (label, series) ->
   "<div style='font-size:8pt; text-align:center; padding:2px; color:white;'>" + label + "<br/>" + Math.round(series.percent) + "%</div>";
renderGender = (selector, data) ->
  $.plot(
    selector,
    data,
    {
      series:
        pie:
          show: true
          innerRadius: 0.2
          radius: 1
          label:
            show: true
            radius: 3/4
            formatter: labelFormatter
            background:
              opacity: 0.5
      legend:
        show: false
    }
  )

buildGenderData = (rawData) ->
  [
    {
      label: "male",
      data: rawData.male,
      color: "#003366"
    },{
      label: "female",
      data: rawData.female,
      color: "#ffb6c1"
    },{
      label: "unknown",
      data: rawData.unknown,
      color: "#FFBB00"
    },
  ]

showGender = (fbData, youtubeData, instagramData) ->

  if fbData
    renderGender('#analytics_graph_gender_facebook', buildGenderData(fbData))
  else
    $("#analytics_graph_gender_facebook").html("Não foi possível carregar os dados de gênero para essa rede social.")

  if youtubeData
    renderGender('#analytics_graph_gender_youtube', buildGenderData(youtubeData))
  else
    $("#analytics_graph_gender_youtube").html("Não foi possível carregar os dados de gênero para essa rede social.")

  if instagramData
    renderGender('#analytics_graph_gender_instagram', buildGenderData(instagramData))
  else
    $("#analytics_graph_gender_instagram").html("Não foi possível carregar os dados de gênero para essa rede social.")

# somatório das interações no periodo
calculateYoutubeEngagement = (info) ->
  if !info.interactions_evolution
    0
  else
    info.interactions_evolution.reduce (memo, d) ->
      memo + d[1]
    , 0

showYoutubeEngagement = (engagement) ->
  $("#youtube_engagement").html(engagement)

# somatório das views no periodo
calculateYoutubeReach = (info) ->
  if !info.reach
    0
  else
    info.reach.reduce (memo, d) ->
      memo + d[1]
    , 0

showYoutubeReach = (reach) ->
  $("#youtube_reach").html(reach)

showFacebookReach = (value) ->
  $("#facebook_reach_value").html(value)

showFacebookEngagement = (value) ->
  $("#facebook_reactions_comments_value").html(value)

showFacebookPostsCount = (value) ->
  $("#facebook_posts_value").html(value)


params = window.analyticsOptions || {}

if not window.has_error
  $.ajax(url: "/api/analytics/info", data: params).success (data) ->

    $("#loading_row").addClass("hidden")
    $("#all_content_row").removeClass("hidden")

    showFollowersEvolution(
      data.fb_info.followers_evolution,
      data.youtube_info.followers_evolution,
      data.instagram_info.followers_evolution,
    )

    showReachEvolution(
      data.fb_info.reach,
      data.youtube_info.reach,
      data.instagram_info.reach,
    )

    showInteractionsEvolution(
      data.fb_info.interactions_evolution,
      data.youtube_info.interactions_evolution,
      data.instagram_info.interactions_evolution,
    )

    showGender(
      data.fb_info.gender,
      data.youtube_info.gender,
      data.instagram_info.gender,
    )

    showYoutubeEngagement(calculateYoutubeEngagement(data.youtube_info))
    showYoutubeReach(calculateYoutubeReach(data.youtube_info))

    showFacebookReach(data.fb_info.reach_sum)
    showFacebookEngagement(data.fb_info.engagement)
    showFacebookPostsCount(data.fb_info.posts)


periodSelectChange = (period) ->
  if period != "custom"
    $("#period_select").attr("disabled", "disabled")
    window.location.search += '&period=' + period
  else
    $("#custom_dates").css(visibility: "visible")


$("#period_select").on("change", ->
  periodSelectChange $(this).val()
)

$("#period_select").removeAttr("disabled")

regional = window.locale || ""
if regional == "en"
  regional = ""

$.datepicker.setDefaults( $.datepicker.regional[ regional ] )

$(".datepicker").each ->
  $(this).datepicker()


# no html ja vem a info de visible baseado no parametro
# periodSelectChange( $("#period_select").val() )


# if fbAccessToken != ''
#   ajaxObj = $.ajax(url: '<%= first_page_insights_api_graph_facebook_index_path %>')
#   ajaxObj.success (data) ->
#     $('#facebook_posts_value').html data.page_stories
#     $('#facebook_reactions_comments_value').html data.last_comments_count + data.reactions_count
#     $('#facebook_reach_value').html data.yesterday_reach
#     $('.label-facebook').html data.page_name
#     if data.last_likes
#       fbData = data.last_likes.map((d) ->
#         endTimeSplited = d.end_time.split('-')
#         date = endTimeSplited[1] + '/' + endTimeSplited[2].split('T')[0]
#         value = d.value
#         [
#           date
#           value
#         ]
#       )
#       showGraphic()
#     return
# else
  # showGraphic()
