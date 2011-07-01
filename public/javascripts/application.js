


$(document).ready(function() {

	
	$('#name').alpha({allow:"., "});
	 
  $('input[title]').inputHints();
	$(".disallowReturn").keypress(function(e) {
		$(this).attr("edited","yes");
          if (e.which == 13) {
              e.preventDefault(); 
			$(this).blur();
              return false;
          }
      });
	logindropopen=0;
	ignoreHide =0;  //hack for body event
	$("#settings").tooltip({position: "bottom center"});
 });


function getAuthToken() {
  var ret = '';

  $.ajax({
    url: '/profile.json', 
    success: function(data) { 
      ret = data['auto_login_token'];
    },
    async: false,
    dataType: 'json'
  });

  return ret;
}

logindropopen = 0;
function openLoginDrop(button) {

	
	if (logindropopen == 0) {
		$(button).css('opacity',1)
		$("#LoginLayer").show();
		$("#LoginCircle2").hide();
		$("#LoginCircleReverse2").show();
		setTimeout('$("#user_email","#LoginLayer").focus();',50);
		$("#LoginButton2").toggleClass('LoginButtonHover'); $("#LoginButton2").toggleClass('test');
		logindropopen=1;
	} else {
		//$(button).css('background-color','#999')
		$("#LoginLayer").hide();
		$("#LoginCircleReverse2").hide();
		$("#LoginCircle2").show();
		$("#LoginButton2").toggleClass('LoginButtonHover'); $("#LoginButton2").toggleClass('test');
		logindropopen=0;
	}
}
function checkLoginLayer() {
	if (logindropopen == 1) {
		if (ignoreHide !=1) {
			openLoginDrop($('#LoginButton'))
		}
	}
	
	if (ignoreHide != 1) {

		$('.dropHiddenLayer').hide();
		
		$('#dropTriangle').show();
		
	}
	
	ignoreHide = 0;
	
	
}



function newUser(button) {
	$(button).css('text-align','center')
	$(button).html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
 	window.location.href='/register'
}

function switchMenuBar(link, active) {

	

	if (active == 0) {
		//jQuery("#HoverMenuBar").css('margin-left',posX+'px')
		//jQuery("#HoverMenuBar""px").css('width',mWidth+'px')
		
		//$('#HoverMenuBar').css('opacity',1)
		
		
		
	} else {

		spotWidth = Math.round($(link).width()) -8;
	    LeftOfLink=$(link).offset().left; 
		CenterTop=$("#TheCenter").offset().left; 
		LeftOfLink = LeftOfLink - CenterTop
	
		$('#TheTab').css("left",LeftOfLink+"px")
		$('#TheTab > .stretch').css("width",spotWidth+"px")
		$('#TheTab').show();
		
		
		jQuery(link).css('color','#fff');
		jQuery(link).css('text-shadow','#0063AA 0 1px 0');
		
	
		
	//	jQuery(link).css('background','#fff');
		switchMenuBar(link, 0);
		setTimeout("$('#ActiveBar').css('opacity',1)",10);
	}
}

function moveTab(link,type) {
	onHoverTimer = 0;
	spotWidth = Math.round($(link).width()) -8;
	LeftOfLink=$(link).offset().left; 
    CenterTop=$("#TheCenter").offset().left; 
	LeftOfLink = LeftOfLink - CenterTop 
	
	if (type == 0) {
		$('#HoverTab').show();
		$('#HoverTab').css('opacity',.2)
		setTimeout("$('#HoverTab').css('opacity',.2)",100)
		$("#HoverTab").animate({left: LeftOfLink+"px"}, 100 );
		$("#HoverTab > .stretch").animate({width: spotWidth+"px"}, 100 );
	} else {
		$("#TheTab").show();
			$("#TheTab").css("left", LeftOfLink+"px")
			$("#TheTab > .stretch").css("width", spotWidth+"px")
	//	$("#TheTab").animate({left: LeftOfLink+"px"}, 100 );
	//	$("#TheTab > .stretch").animate({width: spotWidth+"px"}, 100 );
		
	//	$("#SpotlightLink").css("color","#6090B4")
	//	$("#SpotlightLink").css('text-shadow','#FFFFFF 0 1px 0');
	//	$("#AdventuresLink").css("color","#6090B4")
	//	$("#AdventuresLink").css('text-shadow','#fff 0 1px 0');
	//	$("#LeadersLink").css("color","#6090B4")
	//	$("#LeadersLink").css('text-shadow','#fff 0 1px 0');
		

	 //   $(link).css('color','#fff');
	 //   $(link).css('text-shadow','#0063AA 0 1px 0');

	}
}

function returnHoverBar () {
	onHoverTimer = 1;
	setTimeout("returnHoverBarPerform()",300);
}

function returnHoverBarPerform () {

	if (onHoverTimer == 1) {
	onHoverTimer = 0
		LeftOfLink = $("#TheTab").css('left');
		spotWidth = $("#TheTab > stretch").css('width');

	
		$("#HoverTab").animate({left: LeftOfLink}, 100 );
		$("#HoverTab > .stretch").animate({width: "1px"}, 100 );
		setTimeout("$('#HoverTab').css('opacity',0)",110);
	}
	
	
}

function logoHover() {
$(".template_logo").animate({ opacity: 0}, 500);
//$("#TempLogo").animate({ opacity: 0}, 500);
}
function logoUnhover() {
$(".template_logo").animate({ opacity: 1 }, 500);
//$("#TempLogo").animate({ opacity: 1}, 500);
}


function VerifyLoginForm() {
	error = 0;
	if ($('#user_password','#LoginLayer').val() == '') {
		$('#user_password','#LoginLayer').focus()
		error = 1
	}
	if ($('#user_email','#LoginLayer').val() == '') {
		$('#user_email','#LoginLayer').focus()
		error = 1
	}
	if (error == 0) {
		
		$('#signinbutton','#LoginLayer').html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
		$('#LoginForm','#LoginLayer').submit();
	}
}


function searchKeyPress(myfield,e) {
	
	var code = (e.keyCode ? e.keyCode : e.which);
	
	
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
else return true;

if (keycode == 13) {
		
		theRow = $('#SearchRow'+currentSearchIndex)

		
		window.location.href = $(".BlueLink",theRow).attr('href');
		
			
	//window.location.href = '/search?search_text='+$("#live_search").val()

   return false;
 } else {

	
   		return true;
	
}
}

function attachArrows(myfield,e) {
	
	var code = (e.keyCode ? e.keyCode : e.which);

	
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
else return true;

if (keycode == 38) {		//up
  
  
    currentSearchIndex = currentSearchIndex - 1
    if (currentSearchIndex < 0) {
		currentSearchIndex = maxSearchIndex
	}
	
	$('.searchRows').css('background-color','#fff')
    $('#SearchRow'+currentSearchIndex).css('background-color','#eee')

     return false;

 } else {
   if (keycode == 40) { //down
	
	    currentSearchIndex = currentSearchIndex + 1
	    if (currentSearchIndex > maxSearchIndex) {
			currentSearchIndex = 0
		}

	    $('.searchRows').css('background-color','#fff')
	   $('#SearchRow'+currentSearchIndex).css('background-color','#eee')
	
		return false;
	} else {
		refreshLiveSearch(myfield)
   		return true;
	}
	
}


//up38, down:40

}

function submitOnEnter(myfield,e,type)
{
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
else return true;

if (keycode == 13)
   {
	if (type == 1) {
		error = 0;
		if ($('#user_password','#LoginLayer').val() == '') {
			$('#user_password','#LoginLayer').focus()
			error = 1
		}
		if ($('#user_email','#LoginLayer').val() == '') {
			$('#user_email','#LoginLayer').focus()
			error = 1
		}
		if (error == 0) {
			$('#signinbutton','#LoginLayer').html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
			$('#LoginForm','#LoginLayer').submit();
		}
	}
	if (type == 2) {
		validateRegister(myfield);
	}
	if (type == 3) {
		if ($('#searchfield').val() != '' && $('#searchfield').val() != 'search nearby') {
			$('#SearchForm').submit();
		}
	}
	if (type == 4) {
		if ($('#searchfield3').val() != '' && $('#searchfield3').val() != 'search nearby') {
			$('#SearchForm2').submit();
		}
	}
	if (type == 5) {
		
		
		
		theRow = $('#SearchRow'+currentSearchIndex)
		$(".BlueLink",theRow).trigger('click')
		
		
		
		
		//window.location.href = '/search?search_text='+$("#live_search").val()
	}
	if (type==6) {
		
	}
   return false;
   }
else
   return true;
}




function uploadPhoto() {
	
	txt = '<form id="AvatarUpload" name="AvatarUpload" action="/users/1" method="post" enctype="multipart/form-data"><input id="_method" name="_method" value="PUT" type="hidden"><p class="HighlightedTitle" style="text-align:center">Upload Avatar</p> <input autocomplete="off" class="UploadBox" id="user_avatar" name="user[avatar]" onchange="$.prompt.goToState(\'state1\'); $(\'#AvatarUpload\').submit();" style="cursor:pointer;" type="file" /> <div id="UploadButton" class="SignInConfirm" style="display:none" onclick="$(\'#ProfileEdit\').submit();">upload</div></form>'
	
	//$.prompt(txt, {focus:1, persistent:false, callback: photoUploaded,  buttons: {  Cancel: 'Cancel', Upload: 'Upload' }});
	
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Uploading!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'
	
	

	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: 'Cancel' },
				persistent:false,
	            focus: 1
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v === 0) {
	                    $.prompt.close();
	                }
	            }
	        },
	        state2: {
	            html: 'Test was not successful.<br />',
	            buttons: { Close: 0 },
	            submit: function(v, m, f) {
	                if (v === 0) {
	                    $.prompt.close();
	                }
	            }
	        }
	    };
	    $.prompt(temp);
	
}


function validateRegister(field) {
	
	
	parent = $(field).parent();
	
	$('.Error',parent).html('')
	$('.Error',parent).hide()
	error = 0
	
	if ($('#user_password', parent).val() == '') {
		$('.Error',parent).show()
		$('.Error',parent).html('Password required')
		$('#user_password', parent).focus()
		error = 1
	} else {
		if ($('#user_password', parent).val().length < 4) {
			$('.Error',parent).show()
			$('.Error',parent).html('Needs 4+ characters')
			$('#user_password', parent).val('')
			$('#user_password', parent).focus()
			error = 1
		}
	}
	
	if ($('#user_email', parent).val().length < 2) {
		$('.Error',parent).show()
		$('.Error',parent).html('Email required')
		$('#user_email', parent).focus()
		error = 1
	}
	
	wordcount = verifyName($('#name',parent))
	
	if (wordcount < 2) {
		$('.Error',parent).show()
		$('.Error',parent).html('First and last name required')
		$('#name',parent).focus()
		error = 1	
	}

	if (error == 0) {
		$('#registerbutton',parent).html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
		$(parent).submit();
	}	
}


function highlightChallengeBox(box) {
	 $(box).animate({ backgroundColor: "#E7EEF5" }, 350);
	$('#RightIcon',$(box) ).show()
}

function unHighlightChallengeBox(box) {
	$(box).animate({ backgroundColor: "#eee" }, 350);
	$('#RightIcon',$(box) ).hide()
}


function toggleDrop(drop,event,innerlayer) {
	if (event.stopPropagation) event.stopPropagation(); if (event.preventDefault) event.preventDefault();
	if ( $(innerlayer).is(':visible') ) {
		$(innerlayer).hide();
		$('.dropt', drop).show();
	//	$('.inner',drop).find('.dropHiddenLayer').hide();
	//	$(drop).find('#dropTriangle').show();
		$(drop).css('cursor','pointer')

		
	} else {
		//$('.inner',drop).find('.dropHiddenLayer').show();
		//$(drop).find('#dropTriangle').hide();
		ignoreHide = 1;
		setTimeout("ignoreHide = 0;",100)
		$(innerlayer).show();
		$('.dropt', drop).hide();
			
		if ($(drop).attr('id') == "ShareDrop") {
			$(drop).css('cursor','default')
		}
	}
	if (event.stopPropagation) event.stopPropagation(); if (event.preventDefault) event.preventDefault();
}


function FilterChallenges2(button,label) {
	

	$("#RenderedContent").animate({opacity: .4,}, 100 );
	$("#AppLoadSpinner").show();
	
	window.location.hash = 1;
	page = 1;
	
	if (label == "Cold" || label == "Warm") {
		$("#FilterWeatherBox").show();
		$("#FilterWeatherBox > span").html(label);
	}
	if (label == "Either") {
		$("#FilterWeatherBox").hide();
	}
	
	$.ajax({
       type: "POST",
       url: "/refresh_challenges",
       data: $(button).attr('id') + '='+label+'&['+$(button).attr('id')+'_value='+$(button).val(),
       success: function(msg){
		  $("#RenderedContent").animate({opacity: 1,}, 100 );
		  $("#AppLoadSpinner").hide();
       	  $("#RenderedContent").html(msg)
           infiniteChallenges();
       }
    });
}


function FilterBudget(lowValue,lowLabel,highValue,highLabel) {
	$("#RenderedContent").animate({opacity: .4,}, 100 );
	$("#AppLoadSpinner").show();
	
	window.location.hash = 1;
	page = 1;
	
	
	$.ajax({
       type: "POST",
       url: "/refresh_challenges",
       data: "filter_budget_low_value="+lowValue+"&filter_budget_low="+lowLabel+"&filter_budget_high_value="+highValue+"&filter_budget_high="+highLabel,
       success: function(msg){
		  $("#RenderedContent").animate({opacity: 1,}, 100 );
		  $("#AppLoadSpinner").hide();
       	  $("#RenderedContent").html(msg)
           infiniteChallenges();
       }
    });
}
function FilterDiff(lowValue,lowLabel,highValue,highLabel) {
	$("#RenderedContent").animate({opacity: .4,}, 100 );
	$("#AppLoadSpinner").show();
	
	window.location.hash = 1;
	page = 1;
	
	
	$.ajax({
       type: "POST",
       url: "/refresh_challenges",
       data: "filter_diff_low_value="+lowValue+"&filter_diff_low="+lowLabel+"&filter_diff_high_value="+highValue+"&filter_diff_high="+highLabel,
       success: function(msg){
		  $("#RenderedContent").animate({opacity: 1,}, 100 );
		  $("#AppLoadSpinner").hide();
       	  $("#RenderedContent").html(msg)
           infiniteChallenges();
       }
    });
}


function FilterChallenges(parent,child,field,value,event) {

	if ($(parent).attr("id") == "cityDrop") {
		$("#CityLabel").html($(child).html());
		$("#live_search").css("padding-left",$(".CityChanger").width()+30)
		$("#SearchResults").css("margin-left",$(".CityChanger").width()+25)
		moveTab($("#AdventuresLink"),1)
	}


	$('.value', parent).html($(child).html());
	
$	('.dropHiddenLayer', parent).children().each(function() {
		if ($(child).html() == $(this).html()) {
			$(this).addClass('DropSelected2');
		} else {
			$(this).removeClass('DropSelected2');
		}
	});
	
	chomp = field.slice(0,field.length-1); 
	
	 $("#RenderedContent").animate({opacity: .4,}, 100 );
	$("#AppLoadSpinner").show();
	
	window.location.hash = 1;
	page = 1;
	
	
    $.ajax({
       type: "POST",
       url: "/refresh_challenges",
       data: field + '='+$(child).html()+'&'+chomp+'_value]='+value,
       success: function(msg){
		  $("#RenderedContent").animate({opacity: 1,}, 100 );
		  $("#AppLoadSpinner").hide();
       	  $("#RenderedContent").html(msg)
           infiniteChallenges();
       }
    });
	
	toggleDrop(parent)
	
}

function CreateChallenge(source,optional_text) {
	
	if (source == 1) {
	  title = '<div class="HighlightedTitle" style="text-align:center">Create a Challenge</div><div style=" text-align:center; font-size:10px" class="normalText">If we really like it, we\'ll bake and mail you some tasty brownies.</div> Title'
	}
	if (source == 2) {
	  title = '<div class="HighlightedTitle" style="text-align:center">Create a '+optional_text+' Challenge</div><div style=" text-align:center; font-size:10px" class="normalText">If we really like it, we\'ll bake and mail you some tasty brownies.</div> Title'
	}
	
	txt = '<form id="ChallengeUpload" name="ChallengeUpload" action="/challenges" method="post" enctype="multipart/form-data">'+title+':<br><input class="TextBox RegisterBox" style="width:370px" id="challenge_title" name="challenge[title]" size="56" type="text" value="" /><p>Details:<br><textarea id="challenge_details" name="challenge[details]" class="TextBox ProfileBox" style="height:75px; width:370px"></textarea></p>Photo or Video:<div style="margin-top:-3px; font-size:10px" class="normalText">Show this challenge being accomplished</div><input autocomplete="off" class="UploadBox" id="challenge_photo" name="challenge[photo]" onchange="" style="cursor:pointer;" type="file" /></form>'
	
	//$.prompt(txt, {focus:1, persistent:false, callback: photoUploaded,  buttons: {  Cancel: 'Cancel', Upload: 'Upload' }});
	
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Uploading!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'
	


	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: 'Cancel', Submit: 'Submit' },
				persistent:false,
	            focus: 1,
				submit: function(v, m, f) {

	                if (v ==='Submit') {
	                     $('#ChallengeUpload').submit();
						$.prompt.goToState('state1');					   
						return false;
	                } else { 
						$.prompt.close();
					}
	            }
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v === 0) {
	                    //$.prompt.close();
	                }
	            }
	        },
	        state2: {
	            html: 'Test was not successful.<br />',
	            buttons: { Close: 0 },
	            submit: function(v, m, f) {
	                if (v === 0) {
	                    $.prompt.close();
	                }
	            }
	        }
	    };
	    $.prompt(temp);
	
		$("#challenge_title").focus();
		
		$('#challenge_details').autoResize({
		    // On resize:
		    onResize : function() {
		        $(this).css({opacity:0.8});
		    },
		    // After resize:
		    animateCallback : function() {
		        $(this).css({opacity:1});
		    },
		    // Quite slow animation:
		    animateDuration : 300,
		    // More extra space:
		    extraSpace : 10
		});
}



function uploadAchievement(id) {
	

$.ajax({
   type: "POST",
   url: "/challenges/"+selectedChallenge,
   data: "_method=PUT&challenge[achievement_id]=" + id,
   success: function(msg){
   }
});
	
	txt = '<form id="AchievementUpload" name="AchievementUpload" action="/achievements/'+id+'" method="post" enctype="multipart/form-data"><input id="_method" name="_method" value="PUT" type="hidden"><p class="HighlightedTitle" style="text-align:center">Upload Photo</p> <input autocomplete="off" class="UploadBox" id="user_avatar" name="achievement[photo]" onchange="$.prompt.goToState(\'state1\'); $(\'#AchievementUpload\').submit();" style="cursor:pointer;" type="file" /></form>'
	
	//$.prompt(txt, {focus:1, persistent:false, callback: photoUploaded,  buttons: {  Cancel: 'Cancel', Upload: 'Upload' }});
	
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Uploading!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'
	
	

	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: 'Cancel' },
				persistent:false,
	            focus: 1
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v === 0) {
			
	                    $.prompt.close();
	                }
	            }
	        },
	        state2: {
	            html: 'Test was not successful.<br />',
	            buttons: { Close: 0 },
	            submit: function(v, m, f) {
	                if (v === 0) {
	                    $.prompt.close();
	                }
	            }
	        }
	    };
	    $.prompt(temp);
	
}


function uploadPlanPhoto(id,source) {
	
	txt = '<form id="ChallengeUpload" name="ChallengeUpload" action="/plans/'+id+'" method="post" enctype="multipart/form-data"><input id="_method" name="_method" value="PUT" type="hidden"><p class="HighlightedTitle" style="text-align:center">Upload Photo</p><div class="SubTitle" style="font-weight:normal; padding-bottom:10px">Show off your adventure!  Attach a pic of someone doing it... and looking like they are having fun!</div> <input autocomplete="off" class="UploadBox" id="plan_image" name="plan[image]" onchange="$.prompt.goToState(\'state1\'); $(\'#ChallengeUpload\').submit();" style="cursor:pointer;" type="file" />'
	txt = txt+'</form>'
	
	//$.prompt(txt, {focus:1, persistent:false, callback: photoUploaded,  buttons: {  Cancel: 'Cancel', Upload: 'Upload' }});
	
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Uploading!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'
	
	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: false },
				persistent:false,
	            focus: 0,
				submit: function(v, m, f) {
	        
		  				$.prompt.close();
						return false;
	            }
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v === 0) {
	                    $.prompt.close();
		return false;
	                }
	            }
	        }
	    };
	    $.prompt(temp);	
}


function uploadChallengePhoto(id,source) {
	
	txt = '<form id="ChallengeUpload" name="ChallengeUpload" action="/challenges/'+id+'" method="post" enctype="multipart/form-data"><input id="_method" name="_method" value="PUT" type="hidden"><p class="HighlightedTitle" style="text-align:center">Upload Photo</p><div class="SubTitle" style="font-weight:normal; padding-bottom:10px">Show off your adventure!  Attach a pic of someone doing it... and looking like they are having fun!</div> <input autocomplete="off" class="UploadBox" id="challenge_photo" name="challenge[photo]" onchange="$.prompt.goToState(\'state1\'); $(\'#ChallengeUpload\').submit();" style="cursor:pointer;" type="file" />'
	if (source == 'create') {
		txt = txt + '<input type="hidden" name="redirect_create" id="redirect_create" value="1"'
	}
	txt = txt+'</form>'
	
	//$.prompt(txt, {focus:1, persistent:false, callback: photoUploaded,  buttons: {  Cancel: 'Cancel', Upload: 'Upload' }});
	
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Uploading!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'
	
	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: false },
				persistent:false,
	            focus: 0,
				submit: function(v, m, f) {
	        
		  				$.prompt.close();
						return false;
	            }
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v === 0) {
	                    $.prompt.close();
		return false;
	                }
	            }
	        }
	    };
	    $.prompt(temp);	
}



function openMessageUser(name,history) {
	$("#darkenBackground").show();
	$("#darkenBackground").animate({opacity: .7,}, 100 );
	
	
	var winH = $(window).height()  + (document.body.scrollTop*2); 
    var winW = $(window).width(); 

	var centerDiv = $('#MessageUser'); 
	centerDiv.css('top', (winH/2)-(centerDiv.height()/2)-100); 
    centerDiv.css('left', (winW-centerDiv.width())/2);
	$("#MessageUserTitle").html(name);
	setTimeout("$('#MessageUserField').focus();",100);
	$("#MessageUser").show();
	if (history > 0) {
		$("#HistoryLink").show();
	} else {
		$("#HistoryLink").hide();
	}
}

function sendMessage(button) {

	if ($('#MessageUserField').attr('value') == '') {
		return
	}
	$(button).html('<img style="margin-top:3px" src="/images/ajax-loader_f.gif">')
	
	$.post("/messages", { receiver_id: messageReceiverID, message:$('#MessageUserField').attr('value')}, function(theResponse){
		$('#MessageUserField').attr('value','')
		$(button).html('Reply')
		$("#darkenBackground").animate({ 
	   	opacity: 0,
	  		}, 100 );
		setTimeout("$('#darkenBackground').hide();",150);//
		$("#MessageUser").hide();
			$("#MessageThread").html(theResponse);
	});
	
}


function deleteMessage(row,user_id,unread) {
	if (unread == 1) {
		oldcount = $('#top_unread_count1').html()
		inbox = oldcount - 1
		
		if (inbox == 0) {
			$('#InboxCount').html("<span id='top_unread_count1'>0</span>")
			$('#InboxIcon').attr("src","/images/message.png")
		} else {
			$('#InboxCount').html("(<span id='top_unread_count1'>"+inbox+"</span>)")
		}
		setTimeout("switchMenuBar($('#InboxLink'),1);",10);
		
	}
	
	$.post("/messages/"+user_id, { _method:'delete'}, function(theResponse){
	
	
	});
	
	$(row).next().trigger('onmouseover')
	$(row).remove();
	
	

}

function deleteChatThread(row,id,type,thread) {
	
	$(row).remove();
	
	if (thread == 1) {
		if (type=="delete") {
			$.post("/sparkchat_destroy_thread", { id: id}, function(theResponse){});
		} else {
			$.post("/sparkchat_warn_thread", { id: id}, function(theResponse){	});
		}
	} else {
		if (type=="delete") {
			$.post("/sparkchat_destroy_msg", { id: id}, function(theResponse){});
		} else {
			$.post("/sparkchat_warn_msg", { id: id}, function(theResponse){	});
		}
	}
}

function SendMessage(name,id) {
	txt = '<form id="SendMessageForm" name="SendMessageForm" action="/messages" method="post"><div class="HighlightedTitle" style="text-align:center; margin-bottom:15px;">Send '+name+' a Message</div><textarea id="message" name="message" class="TextBox ProfileBox" style="height:75px; width:370px"></textarea><input type="hidden" id="receiver_id" name="receiver_id" value="'+id+'"></p></form>'
	
	//$.prompt(txt, {focus:1, persistent:false, callback: photoUploaded,  buttons: {  Cancel: 'Cancel', Upload: 'Upload' }});
	
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Sending!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'
	
	

	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: 'Cancel', Send: 'Send' },
				persistent:false,
	            focus: 1,
				submit: function(v, m, f) {
	                if (v == "Send") {
		
						$.post("/messages", { receiver_id: f.receiver_id, message:f.message}, function(theResponse){
							 setTimeout("$.prompt.close();",750);
						});
		
		
	                    $.prompt.goToState('state1'); 
						return false;
	                } 
					
	            }
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v == 0) {
	                    $.prompt.close();
	                }
	            }
	        },
	        state2: {
	            html: 'Test was not successful.<br />',
	            buttons: { Close: 0 },
	            submit: function(v, m, f) {
	                if (v == 0) {
	                    $.prompt.close();
	                }
	            }
	        }
	    };
	    $.prompt(temp);
	
		$("#message").focus();

		$('#message').autoResize({
		    // On resize:
		    onResize : function() {
		        $(this).css({opacity:0.8});
		    },
		    // After resize:
		    animateCallback : function() {
		        $(this).css({opacity:1});
		    },
		    // Quite slow animation:
		    animateDuration : 300,
		    // More extra space:
		    extraSpace : 10
		});
}


function animateDeleteBucket(parent, challenge_id,add) {
	
	$(parent).animate({
		 opacity: .1,
		// marginTop:'-1000px',

	}, 500, function() {
	    $(this).remove();
		grabs_scan();
	} );
	


	$.post("/dislikes", { challenge_id: challenge_id}, function(theResponse){
		 
	});
	
	updateNote('dislike',1)
	
}


function updateNote(type,offset) {
	$('#SaveNote').show()
	$('#SaveNote').animate({
		 height: 57
	});
	
	count = parseInt($("#"+type+"_count").html()) + offset;
	if (count < 0) {
		count = 0;
	}
	
	$("#"+type+"_count_holder").show();
	$("#"+type+"_count").html(count)
}



function animateAddBucket(parent, challenge_id,add,button) {

	
$("#NotLoggedInBucket").show();

$(parent).animate({
	 opacity: .1,
	// marginTop:'-1000px',

}, 500, function() {
    $(this).remove();
} );
	

	
	if (add == 1) {
		
	
	} else {
		
		
		RemoveBucketCount()
		$('#sortable1Tab').html(newcount)
		
		
		
		$.post("/subscribed_challenges/"+challenge_id, { challenge_id: challenge_id, _method:'delete'}, function(theResponse){
		 
		});
	}
	
}

function toggleDislike(button,challenge_id) {
	label = $('#DislikeLabel',button).html();
	
	if (label == "Dislike") {
		$('#DislikeLabel',button).html("Disliked") 
		$(button).removeClass('UnSelected').addClass('HeartSelected')
		$.post("/dislikes", { challenge_id: challenge_id}, function(theResponse){

		});

		updateNote('dislike',1)
		
	} else {
		$('#DislikeLabel',button).html("Dislike") 
		$(button).removeClass('HeartSelected').addClass('UnSelected')
		
		$.post("/dislikes/"+challenge_id, { challenge_id: challenge_id, _method:'delete'}, function(theResponse){

		});
			
		updateNote('dislike',-1)
	}
}


function toggleSave(parent, challenge_id,button,current_user) {

	
	$("#NotLoggedInBucket").show();


	
	label = $('.SaveLabel',button).html();
	
	
	if (label == "Save" || label == "Save to Bucket List") {
		
		$(button).removeClass('UnSelected').addClass('HeartSelected')
		if (label == "Save") {
			$('.SaveLabel',button).html("Saved") 
		} else {
			$('.SaveLabel',button).html("Saved to Bucket List") 
		}
		$('.RateGraphic',button).attr('src','/images/heartSelect.png');
		$('.RateGraphic',button).css('opacity',1);
		AddBucketCount()
	
		$.post("/subscribed_challenges", { challenge_id: challenge_id}, function(theResponse){
		 
		});
		
		updateNote('bucket',1)

		
	} else {
		
		$(button).removeClass('HeartSelected').addClass('UnSelected')
		if (label == "Saved") {
			$('.SaveLabel',button).html("Save") 
		} else {
			$('.SaveLabel',button).html("Save to Bucket List") 
		}
		$('.RateGraphic',button).attr('src','/images/heart.png');
		$('.RateGraphic',button).css('opacity',.6);
		
		RemoveBucketCount()
		$('#sortable1Tab').html(newcount)
		
		$.post("/subscribed_challenges/"+challenge_id, { challenge_id: challenge_id, _method:'delete'}, function(theResponse){
		 
		});
		updateNote('bucket',-1)

	}
	
}


function addBucket(button,challenge_id) {

    text = $(button).html();
	$(button).html('<img src="/images/ajax-loader_f.gif">')
	
	$("#NotLoggedInBucket").show();
		cid = challenge_id;
	
	if (text == "<b>Save</b><br><span style=\"font-size:10px\">to Bucket List</span>") {
	
		AddBucketCount()
	
		$.post("/subscribed_challenges", { challenge_id: challenge_id}, function(theResponse){
			$(button).removeClass("highlightedButton")
			$(button).addClass("redButton")
		    $(button).html("Remove from Bucket")
			$('#tabs').show();
			$.post("/ajax_redraw_planning_box", { id: cid}, function(theResponse){
			    $("#RenderLog").html(theResponse)
				$("#Plan").focus();
		
			});
		});	
		

		
	} else {
		RemoveBucketCount()
		$.post("/subscribed_challenges/"+challenge_id, { challenge_id: challenge_id, _method:'delete'}, function(theResponse){
		 	$(button).removeClass("redButton")
			$(button).addClass("highlightedButton")
		    $(button).html("<b>Save</b><br><span style=\"font-size:10px\">to Bucket List</span>")
			$.post("/ajax_redraw_planning_box", { id: cid}, function(theResponse){
			    $("#RenderLog").html(theResponse)
			});
		
		});
		
	}
	

	
	
}


function AddBucketCount() {
	oldcount = parseInt($('#top_bucket_count1').html());
	if (oldcount) {
		newcount = oldcount + 1
	} else {
		newcount = 1;
	}
	
	if (newcount == 1) {
		$("#insertBucket").html('<span id="BucketCount"><span id="top_bucket_count1">1</span> </span>')
	} else {
		$('#BucketCount').html("<span id='top_bucket_count1'>"+newcount+"</span> ")	
	}
}
function RemoveBucketCount() {
	oldcount = parseInt($('#top_bucket_count1').html())
	newcount = oldcount - 1
	
	if (newcount == 0) {
		$('#BucketCount').html("<span id='top_bucket_count1'></span> ")
	} else {
		$('#BucketCount').html("<span id='top_bucket_count1'>"+newcount+"</span> ")
		
	}

}

function animateFlashMessage() {
	$("#flashMessage").animate({ opacity: "1",}, 300 );
	
	setTimeout("$('#flashMessage').animate({opacity: 0,}, 500); ",1000)	
	
}




function GeoCode_Challenge(location, challenge_id) {

	
	$.post("/geocoder", { location: location, challenge_id:challenge_id}, 
	function(data){
		eval(data);
		if (lat == 0 ) {
			$('#error').html('Could not convert address to GPS coordinates.')
		} else {
	
			mapURL = 'http://maps.google.com/maps/api/staticmap?center='+lat+','+lng+'&zoom=14&size=100x100&maptype=roadmap&markers='+lat+','+lng+'&sensor=false';
			
			//mapURL = 'http://maps.google.com/staticmap?center='+Lat+','+Lng+'&zoom=14&size=90x90&maptype=roadmap&markers='+Lat+','+Lng+'&sensor=false&key=ABQIAAAAd5t8h7gf8hlpFfM_zmOU7hT39yqx9PTFa5e5gPxu0g05YTxiBBQVciAICRx_q0y51mk2-CbIMukdNA';
			//jQuery('#GeoCodeMap').html('<img style="border:1px solid #ccc" src="'+mapURL+'">');
			
			document.getElementById('GoogleMap').src = mapURL;
			$("#ajax").hide();
			$("#GoogleMap").show();
			
			$("#GoogleLink").attr("href", link_url);
			
			$("#challenge_lat").val(lat);
			$("#challenge_lng").val(lng);
			$("#challenge_city").val(city);
		}
	});
}
function GeoCode_Plan(location, plan_id) {

	$.post("/geocode_plan", { location: location, plan_id:plan_id}, 
	function(data){
		eval(data);
		if (lat == 0 ) {
			$('#error').html('Could not convert address to GPS coordinates.')
		} else {
	
			mapURL = 'http://maps.google.com/maps/api/staticmap?center='+lat+','+lng+'&zoom=14&size=270x125&maptype=roadmap&markers='+lat+','+lng+'&sensor=false';
			
			//mapURL = 'http://maps.google.com/staticmap?center='+Lat+','+Lng+'&zoom=14&size=90x90&maptype=roadmap&markers='+Lat+','+Lng+'&sensor=false&key=ABQIAAAAd5t8h7gf8hlpFfM_zmOU7hT39yqx9PTFa5e5gPxu0g05YTxiBBQVciAICRx_q0y51mk2-CbIMukdNA';
			//jQuery('#GeoCodeMap').html('<img style="border:1px solid #ccc" src="'+mapURL+'">');
			
			document.getElementById('GoogleMap').src = mapURL;
			$("#ajax").hide();
			$("#GoogleMap").show();
			
			$("#GoogleLink").attr("href", link_url);
		}
	});
	
}


function blockUser(button,receiver_id,flag,name) {
	
	if (flag == 0) {
		text = $(button).html();

		$(button).html('<img src="/images/ajax-loader_f.gif">')
	
		if (text == "Block") {
			$.post("/blocks", { receiver_id: receiver_id, flag:flag}, function(theResponse){
			    $(button).html("Unblock")
			});	
		} else {
			$.post("/blocks/"+receiver_id, { receiver_id: receiver_id, _method:'delete'}, function(theResponse){
			    $(button).html("Block")
			});
		}
	} else {
	
	
	
	txt = '<form id="SendMessageForm" name="SendMessageForm" action="/blocks" method="post"><div class="HighlightedTitle" style="text-align:center; margin-bottom:15px;">Report '+name+'!</div><div>How is '+name+' violating our <a href="/tos">Terms of Use</a>?</div><textarea id="flag_reason" name="flag_reason" class="TextBox ProfileBox" style="height:75px; width:370px"></textarea><input type="hidden" id="flag" name="flag" value="1"><input type="hidden" id="receiver_id" name="receiver_id" value="'+receiver_id+'"></p></form>'
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Sending!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'

	

	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: 'Cancel', Send: 'FLAG THIS PERSON' },
				persistent:false,
	            focus: 1,
				submit: function(v, m, f) {
	                if (v == "FLAG THIS PERSON") {
		
						$.post("/blocks", { receiver_id: f.receiver_id, flag_reason:f.flag_reason, flag:1}, function(theResponse){
							 setTimeout("$.prompt.close();",750);
							$("#BlockButton").html('Unblock')
						});
		
		
	                    $.prompt.goToState('state1'); 
						return false;
	                } 
					
	            }
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v == 0) {
	                    $.prompt.close();
						
	                }
	            }
	        },
	        state2: {
	            html: 'Test was not successful.<br />',
	            buttons: { Close: 0 },
	            submit: function(v, m, f) {
	                if (v == 0) {
	                    $.prompt.close();
	                }
	            }
	        }
	    };
	    $.prompt(temp);
		$("#flag_reason").focus();
	}
	
}


function newUploadProof(challenge_id,edit,subscribed_id) {
	
	if (edit == 1) {
		txt = '<p class="HighlightedTitle" style="text-align:center">Replace Photo</p>'
	} else {
		txt = '<p class="HighlightedTitle" style="text-align:center">Would you like to attach a photo?</p>'
	}
	if (edit != 1) {
		txt = txt+'<span style="font-weight:normal; color:#666"><ul><li>Share your exploits with friends</li><li>Earn points and rewards</li><li>Fill out your adventure log</li></ul></span>'
	}
	txt = txt+'<form id="SendProofFormPhoto" name="SendProofForm" action="/subscribed_challenges'
	if (edit == 1) { txt = txt+'/'+subscribed_id }
	txt = txt+'" method="post" enctype="multipart/form-data">'
	    txt = txt+'Choose Photo:<br><input autocomplete="off" class="UploadBox" id="challenge_proof" name="challenge[proof]" onchange="$.prompt.goToState(\'state1\'); 	$(\'#SendProofFormPhoto\').submit();" style="cursor:pointer;" type="file" />'
	    txt = txt+'<input type="hidden" id="completed" name="completed" value="1">'
	    txt = txt+'<input type="hidden" id="challenge_id" name="challenge_id" value="'+challenge_id+'">'
	    
	   // txt = txt+'<div style="color:#666; margin-top:15px; font-weight:normal">Optional Note:</div><textarea id="challenge_completed_note" name="challenge[completed_note]" class="TextBox ProfileBox resize" style="height:30px; width:370px"></textarea>'
	    if (edit == 1) {
			txt = txt+'<input type="hidden" id="_method" name="_method" value="PUT">'
		}
	    txt = txt+'</form>'
	
	
	
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Sending!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'


	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: 'Cancel'},
				persistent:false,
	            focus: 1,
				submit: function(v, m, f) {
	                if (v == "Submit") {
					
					    
		
									$("#SendProofFormPhoto").submit();
	
					
		
	                    $.prompt.goToState('state1'); 
						return false;
	                } 
					
	            }
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v == 0) {
	                    $.prompt.close();
						
	                }
	            }
	        }
	    };
	    $.prompt(temp);
	
			$('.resize').autoResize({
			    // On resize:
			    onResize : function() {
			        $(this).css({opacity:0.8});
			    },
			    // After resize:
			    animateCallback : function() {
			        $(this).css({opacity:1});
			    },
			    // Quite slow animation:
			    animateDuration : 300,
			    // More extra space:
			    extraSpace : 10
			});
	
	
	
}

function UnStomp(button,challenge_id) {
	$(button).parent().hide();

	$.post("/subscribed_challenges/"+challenge_id, { challenge_id: challenge_id, _method:'delete'}, function(theResponse){
		
	});
	updateNote('stomped',-1)
	$('.ChallengeSideButton').show();
	$('.planInvite').css("border-top","1px solid #ddd");
	$('.planInvite').css("border-bottom","0px solid #ddd");
			
}
function StompIt(button,challenge_id) {
		parent = $(button).parent();
		didit = $('.ChallengeDoneBox',parent).show(); 
		$('.ChallengeDoneBoxShow',parent).show();
		$('.ChallengeSideButton').hide();
		$('.planInvite').show();
		$('.planInvite').css("border-top","0px");
		$('.planInvite').css("border-bottom","1px solid #ddd");
		
		$.post("/subscribed_challenges?challenge[completed]=1", { challenge_id: challenge_id, completed:1}, function(theResponse){

		});
		updateNote('stomped',1)
		
}


function uploadProof(button,challenge_id,proof,params,edit,subscribed_id) {
	
	formName = "SendProofFormPhoto"
	photochanged = 0;
	
	if (edit == 0) {
		txt = '<div class="HighlightedTitle" style="text-align:center; margin-bottom:5px;">Upload Evidence!</div>'
		txt = txt+'<div>Upload a photo of yourself near the summit sign</div>'
	} else {
		txt = '<div class="HighlightedTitle" style="text-align:center; margin-bottom:5px;">Replace Evidence</div>'
		txt = txt+'<div>Don\'t like what you uploaded?  Replace it.</div>'
	}
	
	txt = txt+'<div style="background:#E7E7E7; margin-bottom:10px; margin-top:10px; border:1px solid #ccc; border-bottom:1px solid #fff">'
	   	txt = txt+'<div id="PhotoButton" class="UploadMenuActive" onclick="UploadMenu(1)">'
			txt = txt+'<img src="/images/uploader_photo.png"><br>Photo'
		txt = txt+'</div>'
		txt = txt+'<div id="VideoButton" class="UploadMenu" onclick="UploadMenu(2)">'
			txt = txt+'<img src="/images/uploader_video.png"><br>Video'
		txt = txt+'</div>'
		txt = txt+'<div style="clear:both"></div>'
	txt = txt+'</div>'
	
	
	
		txt = txt+'<div id="PhotoLayer" style=" display:block">'
		txt = txt+'<form id="SendProofFormPhoto" name="SendProofForm" action="/subscribed_challenges'
		if (edit == 1) { txt = txt+'/'+subscribed_id }
		txt = txt+'" method="post" enctype="multipart/form-data">'
		    txt = txt+'Choose Photo:<br><input autocomplete="off" class="UploadBox" id="challenge_proof" name="challenge[proof]" onchange="photochanged=1" style="cursor:pointer;" type="file" />'
		    txt = txt+'<input type="hidden" id="completed" name="completed" value="1">'
		    txt = txt+'<input type="hidden" id="challenge_id" name="challenge_id" value="'+challenge_id+'">'
		    
		   // txt = txt+'<div style="color:#666; margin-top:15px; font-weight:normal">Optional Note:</div><textarea id="challenge_completed_note" name="challenge[completed_note]" class="TextBox ProfileBox resize" style="height:30px; width:370px"></textarea>'
		    if (edit == 1) {
				txt = txt+'<input type="hidden" id="_method" name="_method" value="PUT">'
			}
		    txt = txt+'</form>'
		txt = txt+'</div>'
		
		txt = txt+'<div id="VideoLayer" style="display:none">'
		txt = txt+'<form id="SendProofForm" name="SendProofForm" action="/subscribed_challenges'
			if (edit == 1) { txt = txt+'/'+subscribed_id }
		txt = txt+'" method="post" enctype="multipart/form-data">'
		    txt = txt+'Choose Video:<br><span id="upload_button" class="panda_upload_button"></span>      '
		    txt = txt+'<input type="text" id="upload_filename"  class="panda_upload_filename"  disabled="yes" style=""/>'
		    txt = txt+'<div id="upload_progress"  class="panda_upload_progress"></div>'
		    txt = txt+'<input type="hidden" name="video[panda_video_id]" id="returned_video_id" value="0" />'
		    txt = txt+'<input type="hidden" id="completed" name="completed" value="1">'
		    txt = txt+'<input type="hidden" id="challenge_id" name="challenge_id" value="'+challenge_id+'">'
		//txt = txt+'<div style="color:#666; margin-top:15px; font-weight:normal">Optional Note:</div><textarea id="challenge_completed_note" name="challenge[completed_note]" class="TextBox ProfileBox resize" style="height:30px; width:370px"></textarea>'
		    if (edit == 1) {
				txt = txt+'<input type="hidden" id="_method" name="_method" value="PUT">'
			}
		    txt = txt+'</form>'
	     txt = txt+'</div>'
		
	
		    
	

	setTimeout('$("#returned_video_id").pandaUploader('+params+', {upload_button_id: "upload_button",upload_progress_id: "upload_progress", upload_filename_id: "upload_filename", upload_strategy: new PandaUploader.UploadOnSelect()})',500);
	
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Sending!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'


	    var temp = {
	        state0: {
	            html: txt,
	            buttons: { Cancel: 'Cancel', Submit: 'Submit' },
				persistent:false,
	            focus: 1,
				submit: function(v, m, f) {
	                if (v == "Submit") {
					
					    
					   	 if (formName == "SendProofForm") {
							if ($("#returned_video_id").val() != "0") {
								$("#SendProofForm").submit();
							} else {
								return false;
							}	
						} else {
					
								
								if (photochanged == 1) {
									$("#SendProofFormPhoto").submit();
								} else {
									return false;
								}
							}
					
		
	                    $.prompt.goToState('state1'); 
						return false;
	                } 
					
	            }
	        },
	        state1: {
	            html: txt2,
	            buttons: { Close: 0 },
	            focus: 0,
	            submit: function(v, m, f) {
	                if (v == 0) {
	                    $.prompt.close();
						
	                }
	            }
	        }
	    };
	    $.prompt(temp);
	
			$('.resize').autoResize({
			    // On resize:
			    onResize : function() {
			        $(this).css({opacity:0.8});
			    },
			    // After resize:
			    animateCallback : function() {
			        $(this).css({opacity:1});
			    },
			    // Quite slow animation:
			    animateDuration : 300,
			    // More extra space:
			    extraSpace : 10
			});
			
	
	
}


function destroyProof(challenge_id) {


    txt = '<div class="HighlightedTitle" style="text-align:center; margin-bottom:15px;">CONFIRM PROOF DELETION</div><div>You WILL lose your points and achievements from this challenge if you continue.  Are you really that embarassed by whatever you uploaded?</div>'
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Deleting Your Stuff!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'


    var temp = {
        state0: {
            html: txt,
            buttons: { Cancel: 'Cancel', Delete: 'Delete' },
			persistent:false,
            focus: 1,
			submit: function(v, m, f) {
                if (v == "Delete") {
				
					
					$.post("/subscribed_challenges/"+challenge_id, { challenge_id: challenge_id, _method:'delete'}, function(theResponse){
					 	window.location.reload();
					});


	
                    $.prompt.goToState('state1'); 
					return false;
                } 
				
            }
        },
        state1: {
            html: txt2,
            buttons: { Close: 0 },
            focus: 0,
            submit: function(v, m, f) {
                if (v == 0) {
                    $.prompt.close();
					
                }
            }
        }
    };
    $.prompt(temp);
}

function UploadMenu(index) {
	if (index == 1) {
		$('#PhotoLayer').show();
		$('#VideoLayer').hide();
		
		$('#PhotoButton').addClass('UploadMenuActive').removeClass('UploadMenu');
		$('#VideoButton').addClass('UploadMenu').removeClass('UploadMenuActive');
		formName = "SendProofFormPhoto"
	} else {
		$('#PhotoLayer').hide();
		$('#VideoLayer').show();
		
		$('#VideoButton').addClass('UploadMenuActive').removeClass('UploadMenu');
		$('#PhotoButton').addClass('UploadMenu').removeClass('UploadMenuActive');
		formName = "SendProofForm"
	}
}



function createVideoLayer(button,id,title,panda_id) {

	
		test = $('#video_content'+id)

		if ($(test).html() ) {
			
			
		} else {
			frame = $('<div />', {"name":"video_content"+id,"id":"video_content"+id, "class":"videoLayers","style":"display:none; width:520px; height:340px; background-color:black; text-align:center"}).appendTo("#flipthis")
			theVideoId = id;
			$.ajax({
		       type: "POST",
		       url: "/regenerate_embed",
		       data: "_method=PUT&panda_id="+panda_id,
		       success: function(msg){
				  $('#video_content'+theVideoId).html(msg);
				}
		    });
		}
		
		

	return hs.htmlExpand(button, { captionText: title, maincontentId: 'video_content'+id, width: '525', height:'380',outlineType: 'rounded-white', align: 'center', dimmingOpacity: 0.75, fadeInOut: true});
}


function postPlan(button,textarea,add,id) {
	text = $(button).html();
	
	if ($(textarea).val() == "") {
		$("#Plan").focus();
		return
	}
	
	$(button).html('<img src="/images/ajax-loader_f.gif">')
	
	if ($("#AddToBucket").html() == "Add to Bucket List") {
		addBucket($('#AddToBucket'),id)
	}
	
	$.post("/add_note", {  challenge_id:id, note:$(textarea).val()}, function(theResponse){
	
		$("#BroadcastPlanBox").html(theResponse)
	});
		
	
}


function openCityDrop() {
	 txt = $("#CityChanger").html();
	
//	txt = '<div class="HighlightedTitle" style="text-align:center; margin-bottom:15px;">Choose your Edition</div><div>Are you sure you want to do this?</div>'
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Deleting Your Challenge!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'
   
 

    var temp = {
        state0: {
            html: txt,
            buttons: {  },
			persistent:false,
            focus: 1,
			submit: function(v, m, f) {
                if (v == "Delete") {
				
					
					$.post("/challenges/"+challenge_id, { challenge_id: challenge_id, _method:'delete'}, function(theResponse){
					 	$(deleteCard).remove();
						$.prompt.close();
					});


	
                    $.prompt.goToState('state1'); 
					return false;
                } 
				
            }
        },
        state1: {
            html: txt2,
            buttons: { Close: 0 },
            focus: 0,
            submit: function(v, m, f) {
                if (v == 0) {
                    $.prompt.close();
					
                }
            }
        }
    };
    $.prompt(temp);


//	$("#OpacitySpotlight").show();
//	$("#OpacitySpotlight").animate({opacity: .8}, 300 );
//	$("#CityDrop").show();
//	$("#CityDrop").animate({opacity: 1}, 300 );
}

function closeCityDrop() {

		$.prompt.close();
//	$("#OpacitySpotlight").animate({ opacity: 0,}, 150 );
//	setTimeout("$('#OpacitySpotlight').hide();",150);
//	$("#CityDrop").animate({ opacity: 0,}, 100 );
//	setTimeout("$('#CityDrop').hide();",150);
}

function chooseCity(city,city_id,page) {
	
	$("#CityLabel").html($(city).html())
	$("#live_search").css("padding-left",$(".CityChanger").width()+30)
	$("#SearchResults").css("margin-left",$(".CityChanger").width()+25)
	
	

	closeCityDrop();
	
	



	if (page == "/" || page == "/new_home") {
		
		if (city_index == city_id & plan_index == 0) {
			return;
		}
		
		
		$('#spinner').show();
		$('#big_image_background').animate({
			 opacity: 0,
		}, 200, function() {} );
		
	
			$.post("/new_refresh_container", { dropdown_city_value:city_id, dropdown_city:$(city).html() }, function(theResponse){
				
				city_index = city_id;
			
				refresh_home(theResponse);
			});
		return;
	}
	
	
	if (page == "/schedule" ) {
		
			$('.spinner2').show();
			$('#OpacityContent').animate({
				 opacity: .3,
			}, 200, function() {} );


				$.post("/schedule", { dropdown_city_value:city_id, dropdown_city:$(city).html() }, function(theResponse){
					$("#RenderContent").html(theResponse)
					$('.spinner2').hide();
					$('#OpacityContent').animate({opacity: 1}, 250);
				
					
				});
			return;
	}
	
	$.post("/new_refresh_container", { dropdown_city_value:city_id, dropdown_city:$(city).html() }, function(theResponse){
				
			
		});
			
	

	
	

	
	
}

function reEnableToolTips() {
	$('.ChallengeBoxBorder').mouseenter(function(){   
		highlightChallengeBox(this)
	});
	$('.ChallengeBoxBorder').mouseleave(function(){    
		unHighlightChallengeBox(this)
	});

	$(".PeopleIcon").tooltip();
	$(".PointIcon").tooltip();
	$(".LocationIcon").tooltip();
	$(".AchievementIcon").tooltip();
	$('.AchievementIconSpot').tooltip();
}



function editAdventureDate(span,id) {
	$( "#datepicker"+id ).focus();
}


function searchBox(box,on) {
	
	if (on == 1) {
		if (box.value=='search') { box.value='';  } else {	setTimeout('SearchOpen()',200)}
		$(box).animate({ width: 200}, 200 );
		$(box).css("color","#666")
		LeftOfLink = parseInt($("#TheTab").css('left')) + 40;
		$("#TheTab").animate({ left: LeftOfLink}, 200 );	
		
		LeftOfHoverLink = parseInt($("#HoverTab").css('left')) + 40;
		$("#HoverTab").animate({ left: LeftOfHoverLink}, 200 );
	} else {	
		if (box.value=='') { box.value='search' }
		$(box).animate({ width: 160}, 200 );
		$(box).css("color","#82AAC5")
		setTimeout('SearchClose()',100)
		LeftOfLink = parseInt($("#TheTab").css('left')) - 40;
		$("#TheTab").animate({ left: LeftOfLink}, 200 );
		
		LeftOfHoverLink = parseInt($("#HoverTab").css('left')) - 40;
		$("#HoverTab").animate({ left: LeftOfHoverLink}, 200 );
	}
}


function refreshLiveSearch(box) {
	
	$.post("/live_search", { search_text: $(box).val()}, function(theResponse){
		$("#SearchResults").html(theResponse);
		
		if ($("#SearchResults").css("display") == "none") {
			SearchOpen();
		}
		
	});
	
}

function SearchOpen() {
	$("#SearchResults").show();
	$("#OpacitySpotlight").show();
	$("#OpacitySpotlight").animate({opacity: .8}, 300 );
}
function SearchClose() {
	$("#SearchResults").hide();
	$("#OpacitySpotlight").animate({ opacity: 0,}, 150 );
	setTimeout("$('#OpacitySpotlight').hide();",150);
}

function clickSearchIcon() {
	if ( $("#live_search").val() == "search" || $("#live_search").val() == "" ) {
		$("#live_search").focus();
	} else {
		window.location.href = "/search?search_text="+$("#live_search").val()
	}
	
}

function onSearchReturn() {
	
}



function instruct(action) {
	$("#DefaultInstructions").hide();
	$("#TitleInstructions").hide();
	$("#DetailInstructions").hide();
	$("#ProofInstructions").hide();
	$("#LocationInstructions").hide();
	
	$("#DefaultInstructions").css("opacity",0);
	$("#TitleInstructions").css("opacity",0);
	$("#DetailInstructions").css("opacity",0);
	$("#ProofInstructions").css("opacity",0);
	$("#LocationInstructions").css("opacity",0);
	
	if (action == "off") {
		$("#DefaultInstructions").show();
		$("#DefaultInstructions").animate({ opacity: 1,}, 350 );
	}
	if (action == "title") {
		$("#TitleInstructions").show();
		$("#TitleInstructions").animate({ opacity: 1,}, 350 );
	}
	if (action == "detail") {
		$("#DetailInstructions").show();
		$("#DetailInstructions").animate({ opacity: 1,}, 350 );
	}
	if (action == "proof") {
		$("#ProofInstructions").show();
		$("#ProofInstructions").animate({ opacity: 1,}, 350 );
	}
	if (action == "location") {
		$("#LocationInstructions").show();
		$("#LocationInstructions").animate({ opacity: 1,}, 350 );
	}
	
}


function submitChallenge(button) {
	if ($(button).html() == "Create") {
		$(button).css("opacity",.5)
		$(button).html('<img src="/images/ajax-loader_f.gif">')
		$('#ChallengeUpload').submit();
	}
}


function ChallengeLocationBlur(input) {
	if ($(input).val() != "") {
		$(input).animate({ width: 325}, 200 );
		GeoCode_Challenge($(input).val(),0)
		setTimeout("$('#MapDisplay').show();",200)
	}
}


function deleteMyChallenge(card,challenge_id) {
	txt = '<div class="HighlightedTitle" style="text-align:center; margin-bottom:15px;">CONFIRM CHALLENGE DELETION</div><div>Are you sure you want to do this?</div>'
	txt2 = '<p class="HighlightedTitle" style="text-align:center">Deleting Your Challenge!  Please wait.</p><div style="padding-top:5px" align="center"><img src="/images/ajax-loader-bar.gif"</div>'
    deleteCard = card;

    var temp = {
        state0: {
            html: txt,
            buttons: { Cancel: 'Cancel', Delete: 'Delete' },
			persistent:false,
            focus: 1,
			submit: function(v, m, f) {
                if (v == "Delete") {
				
					
					$.post("/challenges/"+challenge_id, { challenge_id: challenge_id, _method:'delete'}, function(theResponse){
					 	$(deleteCard).remove();
						$.prompt.close();
						updateNote('created',-1)
					});


	
                    $.prompt.goToState('state1'); 
					return false;
                } 
				
            }
        },
        state1: {
            html: txt2,
            buttons: { Close: 0 },
            focus: 0,
            submit: function(v, m, f) {
                if (v == 0) {
                    $.prompt.close();
					
                }
            }
        }
    };
    $.prompt(temp);
}



function infiniteChallenges() {
	
	
 $("#MenuCategories").html($('#HiddenMenu').html())

 if (noResults == true) {
	$("#MenuCategories").hide();
	$("#HighlightedBar").hide();
	$("#SelectedBar").hide();
} else {
	$("#MenuCategories").show();
	$("#HighlightedBar").show();
	$("#SelectedBar").show();
}


	

SelectedPos = selectedCategoryH + 10;
$("#HighlightedBar").css({marginTop: SelectedPos+'px'})
$("#SelectedBar").css({marginTop: SelectedPos+'px'})



//alert(selectedColumn)

	window.infinitescroll = $('#RenderedContent').infinitescroll({

	  navSelector  : "div.pagination",            
	                 // selector for the paged navigation (it will be hidden)
	  nextSelector : "div.pagination > .next_page",    
	                 // selector for the NEXT link (to page 2)
	  itemSelector : ".ChallengeBoxBorder" ,

	  loadingText  : "Loading more challenges...",   
	  },function(arrayOfNewElems){
	    $('.ChallengeBoxBorder').mouseenter(function(){   
			highlightChallengeBox(this)
		});
		$('.ChallengeBoxBorder').mouseleave(function(){    
			unHighlightChallengeBox(this)
		});
		grabs_scan();
		
	    var counter = 1;
	    $("#RenderedContent > .ChallengeBoxBorder").each(function() {
		
		if (counter > 12*page)  {
		  $(".AchievementIcon",this).tooltip();
		  $(".PeopleIcon",this).tooltip();
		  $(".PointIcon",this).tooltip();
		  $(".LocationIcon",this).tooltip();
		$(this).css("opacity",.1);
		 }
		 counter++;
		});


	    page = parseInt(page) + 1;

	    window.location.hash = page
	
	


	});
	
	
grabs_scan();
}

function verifyName(input) {
	words =  $.trim($(input).val());
	wordCount = words.split(' ').length;
	if (wordCount < 2) {
		$("#name_error").html('First and last name required.');
		$("#name_error").show();
	} else {
		$("#name_error").hide();
	}
	
	return wordCount
}



function validateSettings() {
	error = 0;
	
	if ($("#verify_password").val() != $("#new_password").val()) {
		error = 1;
		$("#password_error").show();
	}
	
	if (error == 0) {
		$('#ProfileEdit').submit();
	}
}




function InviteBox(box,on) {
	if (on == 1) {
		if (box.value=='emails') { box.value='';  }
		$(box).css("color","#666")
	} else {
		if (box.value=='') { box.value='emails' }
		$(box).css("color","#ccc")
	}
}


function PopOff(field) {
	if ($(field).is(':checked')) {
		$("#FacebookPop").show()
		$('#fb_post_wall').attr('checked',true); 
	} else {
		$("#FacebookPop").hide()
		$('#fb_post_wall').attr('checked',false);
		$('#fb_create_event').attr('checked',false);  
	}
}

function closeFBPop() {
	if ( $("#fb_post_wall").attr('checked') == false && $("#fb_create_event").attr('checked') == false  ) {
		$("#FacebookPop").hide()
		$('#share_fb').attr('checked',false); 
	}
}

function toggleCheck(field) {
		
	if ( $(field).attr('checked') ) {
		$(field).attr('checked',false); 
			PopOff($('#share_fb'))
	} else {
		$(field).attr('checked',true); 	
		
		PopOff($('#share_fb'))
		
	}
}


function submitInvite(button) {
	if ($("#Plan").val() == "") {
		$("#Plan").focus();
		return
	}
	
	if ($('#fb_create_event').is(':checked')) {
		if ($("#DatePicker").val() == "") {
			$("#DatePicker").focus()
			return;
		}
	}
	
	if ( $("#share_fb").attr('checked') == false && $("#share_twitter").attr('checked') == false  && $("#share_stomp").attr('checked') == false  && $("#Invite").val() == "emails" ) {
		$("#NoBoxError").show();
		return
	}
	
	$(button).html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
	
}


function togglePublished(button,id) {
	if ($(button).html() == "published") {
		$(button).html("unpublished")
		value = 0

	
		
	} else {
		$(button).html("published")
		value = 1
		
	}
	
	$.ajax({
       type: "POST",
       url: "/challenges/"+id,
       data: "_method=PUT&challenge[published]=" + value,
       success: function(msg){
       }
    });

}


function toggleLog() {
	if (toggleAdventureLog == "gallery") {
		toggleAdventureLog = "text";
			$('#AdventurePhotoGallery').animate({opacity: 0,}, 200, function() {$(this).hide();});
			
			setTimeout("$('#AdventureLogText').show(); $('#AdventureLogText').animate({opacity: 1}, 200)",200)
		
		$('#toggleList').removeClass('toggleButton').addClass('toggleButtonActive')
		$('#togglePhoto').addClass('toggleButton').removeClass('toggleButtonActive')
		
		$.cookie("toggleAdventureLog", "text");
		
		
	} else {
		toggleAdventureLog = "gallery";
		$('#AdventureLogText').animate({
		 	opacity: 0,
		}, 200, function() {
	    	$(this).hide();
		} );
		
		setTimeout("$('#AdventurePhotoGallery').show(); $('#AdventurePhotoGallery').animate({opacity: 1}, 200)",200)
		
			$('#togglePhoto').removeClass('toggleButton').addClass('toggleButtonActive')
			$('#toggleList').addClass('toggleButton').removeClass('toggleButtonActive')
		
		$.cookie("toggleAdventureLog", "gallery");
			
	}
}

function toggleMyProfile() {
	if (toggleMy == "card") {
		toggleMy = "list";
		
		$('#MyCard').animate({opacity: 0,}, 200, function() {$(this).hide();});
			
		setTimeout("$('#MyList').show(); $('#MyList').animate({opacity: 1}, 200)",200)
		
		$('#toggleList3').removeClass('toggleButton').addClass('toggleButtonActive')
		$('#togglePhoto3').addClass('toggleButton').removeClass('toggleButtonActive')
		
		$.cookie("toggleMy", "list");
		
		
	} else {
		toggleMy = "card";
		$('#MyList').animate({
		 	opacity: 0,
		}, 200, function() {
	    	$(this).hide();
		} );
		
		setTimeout("$('#MyCard').show(); $('#MyCard').animate({opacity: 1}, 200)",200)
		
			$('#togglePhoto3').removeClass('toggleButton').addClass('toggleButtonActive')
			$('#toggleList3').addClass('toggleButton').removeClass('toggleButtonActive')
		
		$.cookie("toggleMy", "card");
			
	}
}



function toggleBucketProfile() {
	if (toggleBucket == "card") {
		toggleBucket = "list";
		
		$('#BucketCard').animate({opacity: 0,}, 200, function() {$(this).hide();});
			
		setTimeout("$('#BucketText').show(); $('#BucketText').animate({opacity: 1}, 200)",200)
		
		$('#toggleList2').removeClass('toggleButton').addClass('toggleButtonActive')
		$('#togglePhoto2').addClass('toggleButton').removeClass('toggleButtonActive')
		
		$.cookie("toggleBucket", "list");
		
		
	} else {
	
		toggleBucket = "card";
		$('#BucketText').animate({
		 	opacity: 0,
		}, 200, function() {
	    	$(this).hide();
		} );
		
		setTimeout("$('#BucketCard').show(); $('#BucketCard').animate({opacity: 1}, 200)",200)
		
			$('#togglePhoto2').removeClass('toggleButton').addClass('toggleButtonActive')
			$('#toggleList2').addClass('toggleButton').removeClass('toggleButtonActive')
		
		$.cookie("toggleBucket", "card");
			
	}
}

function focusNote(box,type) {
	if (type == 1) {
		if (box.value=='write a note if you\'d like people to join you') { box.value='';  } 
		parent1=$(box).parent();
		$('.commentPlanSubmit', parent1).show();
		
		//$('#NoteSubmit').show();
	} else {
		if (box.value=='comment') { box.value='';  } 
		parent1=$(box).parent();
		$('.SubmitButton', parent1).show();
		
	}
	
	
	
	

	
	
	$(box).css("color","#333")
}
stopClose = 0;
function blurNote(box,type) {
	if (type == 1) {
		if (box.value=='') { box.value='write a note if you\'d like people to join you' }
			parent=$(box).parent();
			setTimeout("if (stopClose != 1) { 	$('.commentPlanSubmit', parent).hide();}",200);
	} else {
		if (box.value=='') { box.value='comment' }
		parent=$(box).parent();
		
		setTimeout("if (stopClose != 1) { $('.SubmitButton', parent).hide();}",200);
	}

	$(box).css("color","#ccc")
}





function addNote(box,id,source) {
	stopClose=1;
	$(box).html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
	parent2=$(box).parent();
	$.ajax({
        type: "POST",
        url: "/initial_comment",
        data: "_method=PUT&source="+source+"&id="+id+"&subscribed_challenge[note]=" + $('.commentPlan', parent).val(),
        success: function(msg){
			stopClose=0;
			$('#CommentsArea'+id).html(msg)
		//	$('.smallThumpUp','#CommentsArea'+id).tooltip();
			$('.resize').autoResize({
			    // On resize:
			    onResize : function() {
			        $(this).css({opacity:0.8});
			    },
			    // After resize:
			    animateCallback : function() {
			        $(this).css({opacity:1});
			    },
			    // Quite slow animation:
			    animateDuration : 300,
			    // More extra space:
			    extraSpace : 1
			});
        }
     });


}



function postComment(box,plan_id) {

	parent=$(box).parent().parent();
	
	value = $('.resize', parent).val();
	
	if (value == 'comment') {
		$('.resize', parent).focus();
		return;
	}
	
	$('.InnerLightGrayBorder',box).html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
	theBox = $('.InnerLightGrayBorder',box)
	$('.resize', parent).val('comment');
	$('.resize', parent).css('color','#ccc')
	$('.resize', parent).css('height','20px')
	stopClose=1;
	id=plan_id;
	
	
	
	$.ajax({
        type: "POST",
        url: "/comments",
        data: "comments[comment]=" + value + "&comments[plan_id]="+plan_id,
        success: function(msg){
			stopClose=0;
			$(theBox).html('Post')
			$('#CommentsArea'+id).html(msg)
		
        }
     });

}


function addLike(buton,subscribed_challenge_id,challenge_id) {
	
	parent = $(buton).parent();
	$(buton).hide();
	$(".thumbDown",parent).show();

	id=subscribed_challenge_id;
	$.ajax({
        type: "POST",
        url: "/likes",
        data: "likes[subscribed_challenge_id]="+subscribed_challenge_id,
        success: function(msg){
			$('#LikesArea'+id).html(msg)
        }
     });

	//if ($("#AddToBucket").html() == "Add to Bucket List") {
	//	addBucket($('#AddToBucket'),challenge_id)
	//}
	
}

function deleteLike(buton, subscribed_challenge_id) {
	
	parent = $(buton).parent();
	$(buton).hide();
	$(".thumbUp",parent).show();
	
	
	id=subscribed_challenge_id;
	$.post("/likes/"+subscribed_challenge_id, { _method:'delete'}, function(theResponse){
	
		$('#LikesArea'+id).html(theResponse)
	});
}
		
function togglePrivacy(box,id) {
	if ($(".privacycomment",box).html() == "commenting disabled") {
		$(".privacyicon",box).attr("src","/images/unlock.png");
		$(".privacycomment",box).html('anyone can comment')
		value=0;
		$("#commentlayer"+id).show();

	} else {
		$(".privacyicon",box).attr("src","/images/lock.png");
		$(".privacycomment",box).html('commenting disabled');
		value=1;
		$("#commentlayer"+id).hide();
	}
	
	$.ajax({
       type: "POST",
       url: "/subscribed_challenges/"+id,
       data: "_method=PUT&challenge[private]=" + value,
       success: function(msg){
       }
    });
	
	
}



function submitPostOnEnter(myfield,id)
{
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
else return true;

if (keycode == 13)
   {
	parent=$(myfield).parent();

	
	
	button = $('.WhiteActiveBorder', parent)
button2 = $('.LightGrayButton', button)
	postComment(button2,id)
	$(myfield).blur();
   return false;
   }
else
   return true;
}


function toggleMenu(button,layer) {




	if ($('.MinusPlusCircle',button).html() == "-") {
		$('.MinusPlusCircle',button).html('+')
		$(layer).hide();
		if ($(layer).attr('id')=="MenuCategories") {
			$('#HighlightedBar').hide();
			$('#SelectedBar').hide();
		}
		
	} else {
		$('.MinusPlusCircle',button).html('-')
		$(layer).show();
		if ($(layer).attr('id')=="MenuCategories") {
			$('#HighlightedBar').show();
			$('#SelectedBar').show();
		}
	}
	
	
	
}


function moveHighlightBar(button,top) {
	//top = $(button).css('margin-top');
    top = top+10;

	$("#HighlightedBar").animate({marginTop: top+"px"}, 50);
}
//$("#HoverMenuBar").animate({ 

function returnHightlightBar() {
	returnPos = SelectedPos +1;
	$("#HighlightedBar").animate({marginTop: SelectedPos+'px'}, 50);
}

function chooseCategory(button,top,type) {
	top = top+10;
	SelectedPos = top;
	$("#SelectedBar").animate({marginTop: top+"px"}, 50);
	
	
	$("#RenderedContent").animate({opacity: .4,}, 100 );
	$("#AppLoadSpinner").show();
	
	window.location.hash = 1;
	page = 1;
	
	
	$.ajax({
       type: "POST",
       url: "/refresh_challenges",
       data: 'filter_category='+type,
       success: function(msg){
		  $("#RenderedContent").animate({opacity: 1,}, 100 );
		  $("#AppLoadSpinner").hide();
       	  $("#RenderedContent").html(msg)
           infiniteChallenges();
       }
    });
	
	
}

function chooseCategorySpot(type) {
$.ajax({
   type: "POST",
   url: "/refresh_challenges",
   data: 'filter_category='+type,
   success: function(msg){
	window.location.href='/adventures'
   }
});
}


function openRegister(title) {
	$(".registerTitle").html(title)
	$("#BlackModal").show();
	$("#BlackModal").animate({opacity: .4,}, 100 );
	$("#BlackModal").height($(document).height())
	setTimeout("centerBox($('#RegisterModal')); $('#RegisterModal').show();  $('#RegisterModal').animate({ opacity: 1,}, 250 );",50);
}

function closeRegister() {
	
	if ($("#RegisterModal").is(":visible")) {
	
		$("#BlackModal").animate({ 
	   		opacity: 0,
	  		}, 100 );
			setTimeout("$('#BlackModal').hide();",150);

			$.cookie('showAttendPop', null, { path: '/plans/'});
			$.cookie('watchPlan', null, { path: '/plans/'});
			$("#RegisterModal").hide();
			$("#RegisterModal").css('opacity',0)
		
			$("#RenderAchievements").hide();
		}
		
		
}

function centerBox(box) {
    $(box).css("position","absolute");
    $(box).css("top", ( $(window).height() - $(box).height() ) / 2+($(window).scrollTop()-30) + "px");
    $(box).css("left", ( $(window).width() - $(box).width() ) / 2+$(window).scrollLeft() + "px");
}

function toggleUserMenu(layer) {
	setWidth = $('#UserLinkMenu').width()+5; 
	if (setWidth < 65) {
		setWidth = 65;
	}
	left = $('#UserLinkMenu').position().left; 

	
	$('#LogoutMenu').toggle(); 
	
	 
	$('#LogoutMenu').width(setWidth); 
	$('#LogoutMenu').css('margin-left',left+'px') 
	
	if ( $('#LogoutMenu').is(':visible') ) {
		$("#UserLinkMenu > .UserLink").css("color","#21547E")
		$("#UserLinkMenu > .UserLink").css("text-shadow","#FFFFFF 0 1px 0")
		$("#UserLinkMenu").css("background","#fff")
		$("#UserLinkMenu").css("border","1px solid #7094AC")
	} else {
		$("#UserLinkMenu > .UserLink").css("color","white")
			
		$("#UserLinkMenu > .UserLink").css("text-shadow","#000 0 1px 0")
		
		$("#UserLinkMenu").css("background","none")
		$("#UserLinkMenu").css("border","1px solid transparent")
	}
}

function userMenuMouseOver() {
	if ( $('#LogoutMenu').is(':visible') ) {
		
	} else {
		$("#UserLinkMenu > .UserLink").css("color","#21547E")
		$("#UserLinkMenu > .UserLink").css("text-shadow","#FFFFFF 0 1px 0")
	
		$("#UserMenuArrow").addClass("upArrowIcon").removeClass("WhiteTriangle");
		
		$("#UserLinkMenu").css("background","#fff")
		$("#UserLinkMenu").css("border","1px solid #6F9CB9")
	}
}
function userMenuMouseOut() {
	if ( $('#LogoutMenu').is(':visible') ) {
		
	} else {
		
		$("#UserMenuArrow").addClass("WhiteTriangle").removeClass("upArrowIcon");
		
		
			$("#UserLinkMenu > .UserLink").css("color","white")
			$("#UserLinkMenu > .UserLink").css("text-shadow","#000 0 1px 0")
		$("#UserLinkMenu").css("background","none")
		$("#UserLinkMenu").css("border","1px solid transparent")
	}
}


function closeUserMenu() {
	if ( $('#LogoutMenu').is(':visible') ) {
		$('#LogoutMenu').hide(); 
		$("#UserMenuArrow").addClass("WhiteTriangle").removeClass("upArrowIcon");
		//	$("#UserLinkMenu").removeClass("UserLinkMenuActive")
			$("#UserLinkMenu > .UserLink").css("color","white")
			$("#UserLinkMenu > .UserLink").css("text-shadow","#000 0 1px 0")
		$('#UserLinkMenu').css('background','none')
		$("#UserLinkMenu").css("border","1px solid transparent")
	}
}

function grabs_scan() { // lazy load f/x

		$('.ChallengeBoxBorder').each( function(i,n) {
			if( $(n).offset().top < $(window).scrollTop() + $(window).height() -10) {
				
				$(n).animate({opacity: 1}, 600 );  //fadeIn
			}
		} );
	}
	
	
function maybePlan(button,render,plan_id) {
	outer = $(".outerB",button)
	inner = $(".innerB",outer)
	label = $(inner).html()
	id = plan_id;
	countmein = $(".countmein",$(button).parent().parent())
	outer_count = $(".outerB",countmein)
	inner_count = $(".innerB",outer_count)
	
	if (label == "Maybe") {
		$(inner).html("Maybe?");
		$(outer).addClass("RedButton").removeClass("LightGrayButton")
		$(inner).addClass("InnerRedBorder").removeClass("InnerLightGrayBorder")
		
		$(outer_count).addClass("LightGrayButton").removeClass("GreenButton")
		$(inner_count).addClass("InnerLightGrayBorder").removeClass("InnerGreenBorder")
		
		$.post("/subscribed_plans", { plan_id:plan_id, maybe:1}, function(theResponse){
				$('#RenderPlan').html(theResponse)
		});
		
		
	} else {
		$(inner).html("Maybe");
		$(outer).addClass("LightGrayButton").removeClass("RedButton")
		$(inner).addClass("InnerLightGrayBorder").removeClass("InnerRedBorder")
		
		$(outer_count).addClass("GreenButton").removeClass("LightGrayButton")
		$(inner_count).addClass("InnerGreenBorder").removeClass("InnerLightGrayBorder")
		
		$.post("/subscribed_plans/"+plan_id, { plan_id:plan_id, _method:'delete'}, function(theResponse){
				$('#RenderPlan').html(theResponse)
		});
		
	}	
}	
	
	
function watchMouseDown(button) {
	label = $(button).html()
	if (label == "Watch") {
		$(button).addClass("newGrayButtonPushed").removeClass("newGrayButton")
	} else {
		$(button).addClass("newGrayButton").removeClass("newGrayButtonPushed")
	}
}	

function watchMouseUp(button) {

	label = $(button).html()
	if (label == "Watching") {
		$(button).addClass("newGrayButtonPushed").removeClass("newGrayButton")
	}
	if (label == "Watch") {
		$(button).addClass("newGrayButton").removeClass("newGrayButtonPushed")
	}
}


	
function watchPlan(button,plan_id) {
	label = $(button).html()
	$(button).html('<img style=\'margin-top:3px;\' src=\'/images/ajax-loader_f.gif\'>');
	
	
	if (label == "Watch") {
		$.post("/watched_plans", { plan_id:plan_id}, function(theResponse){		
			
			$(button).html("Watching");
		});
	} else {
		$.post("/watched_plans/"+plan_id, { plan_id:plan_id, _method:'delete'}, function(theResponse){
			
			$(button).html("Watch");
		});
	}
}
	
function signupPlan(button,render,plan_id) {
		label = $(button).html()
		id = plan_id;
		$(button).html('<img style=\'margin-top:3px;\' src=\'/images/ajax-loader_f.gif\'>');
	
		if (label == "Sign Up: FREE") {
			
			
				$.post("/subscribed_plans", { plan_id:plan_id, maybe:0}, function(theResponse){
					
						seats_remaining = seats_remaining - 1;

						$("#seat_remain").html(seats_remaining)
						
					$(button).addClass("RedB").removeClass("GreenB").removeClass("LightGrayButton")
					$(button).html("I'm coming!");
						$('#RenderPlan').html(theResponse)
				});
	
			
		} else {
			
	
			
			$.post("/subscribed_plans/"+plan_id, { plan_id:plan_id, _method:'delete'}, function(theResponse){
				
					seats_remaining = seats_remaining + 1;
					$("#seat_remain").html(seats_remaining)
					
					$(button).addClass("GreenB").removeClass("RedB")
				$(button).html("Sign Up: FREE");
					$('#RenderPlan').html(theResponse)
			});
		}
}

function signUpFree(plan_id) {
	$.post("/subscribed_plans", { plan_id:plan_id, maybe:0}, function(theResponse){
		window.location.reload();
	});
}

function animateSpinner(button) {
	$(button).html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
}



function prevChallenge() {
	
}



function advanceChallenge(offsetPage) {
	if (event.stopPropagation) event.stopPropagation(); if (event.preventDefault) event.preventDefault();
	opacity = $("#RightArrow").css("opacity");
	
	if (opacity < .5) {
		return;
	}
	
	$("#RightArrow").css("opacity",".3");
	
	currentChallenge = currentChallenge + offsetPage;
	
	maxChallenge = parseInt($('#ChallengeCountTitle').html());
	if (currentChallenge > maxChallenge) {
		currentChallenge = 1;
	}
	if (currentChallenge < 1) {
		currentChallenge = 1;
	}
	
	$.cookie("spot_page", currentChallenge);
	
	
	if (currentChallenge == 1) {
		$("#backButton").css("opacity",.3);
	} else {
			$("#backButton").css("opacity",1);
	}
	
	 if (offsetPage == 1) {
		$('#BehindImage').attr("src",$('#TempNextInfo > .NextImage').attr("src"));
		$('#TempBackChallenge').html($('#CurrentInfo').html())
	} else {
		if (currentChallenge == 1) {
			$('#BehindImage').attr("src",$('#ThePlan > .NextImage').attr("src"));
		} else {
			$('#BehindImage').attr("src",$('#TempBackChallenge > .NextImage').attr("src"));
		}
		$('#TempNextInfo').html($('#CurrentInfo').html())
	}
	
	$('#CurrentInfo').animate({opacity: 0,}, 300, function() {
		if (offsetPage == 1) {
			
			$('#CurrentInfo').html($('#TempNextInfo').html())
		} else {
			if (currentChallenge == 1) {
				$('#CurrentInfo').html($('#ThePlan').html())
			} else {
				$('#CurrentInfo').html($('#TempBackChallenge').html())
			}
		}
		setTimeout("$('.auto').ellipsis();",310);
		$('#CurrentInfo').animate({opacity: 1}, 300);
		$('#CurrentInfo > .tip').each( function(i,n) {
			$(this).tooltip();
		} );
		$('a.lightbox').lightBox({imageLoading: '/images/loading.gif',
			imageBtnClose: '/images/close.gif',
			imageBtnPrev: '/images/prev.gif',
			imageBtnNext: '/images/next.gif'});
		$("#CurrentCount1").html(currentChallenge)
		$("#CurrentCount2").html(currentChallenge)
		
		if (offsetPage == 1) {
			$("#CurrentLabel1").html($("#TempNextInfo > .NextLabelHolder").html())
			$("#CurrentLabel2").html($("#TempNextInfo > .NextLabelHolder").html())
		} else {
			if (currentChallenge == 1) {
				$("#CurrentLabel1").html($("#ThePlan > .NextLabelHolder").html())
				$("#CurrentLabel2").html($("#ThePlan > .NextLabelHolder").html())
			} else {
				$("#CurrentLabel1").html($("#TempBackChallenge > .NextLabelHolder").html())
				$("#CurrentLabel2").html($("#TempBackChallenge > .NextLabelHolder").html())
			}
		}
	});

	$('#BehindImage').css("opacity",1)

	$('#MainImage').animate({opacity: 0,}, 500, function() {
		$('#MainImage').attr("src",$('#BehindImage').attr("src"));
		$('#MainImage').css("opacity",1)
		$('#BehindImage').css("opacity",0)
		
		if (offsetPage == 1) {
			$.post("/next_challenge", { page: currentChallenge}, function(theResponse){
				$('#TempNextInfo').html(theResponse);
				$("#RightArrow").animate({opacity:1},300);			
			});
		} else {
			if (currentChallenge > 1) {
				$.post("/next_challenge", { page: currentChallenge-2}, function(theResponse){
					$('#TempBackChallenge').html(theResponse);
					$("#RightArrow").animate({opacity:1},300);			
				});
			} else {
				$("#RightArrow").animate({opacity:1},300);	
			}
		}
	});
	

				
	
}	

function animateLabel(on) {
	
	opacity = $('#ImageLabel').css("opacity")
	
	if (on == 1) {
		if (opacity != .8) {
			$('#ImageLabel').stop();
			$('#ImageLabel').animate({opacity: .9}, 	500);
		}
	} else {
		if (opacity != 0) {
			$('#ImageLabel').stop();
			$('#ImageLabel').animate({opacity: .7}, 500);
		}	
	}
}	


function CharacterCount(input) {
	
	value = $(input).val().length;
	
	chars_left = 60 - value;
	if (chars_left < 60) {
		$("#CharacterCount").show();
		$("#CharacterCount").html(chars_left);
	} else {
		$("#CharacterCount").hide();
	} 
	
	$.ajax({
	   type: "POST",
	   url: "/create_search_results",
	   data: 'search_text='+$(input).val(),
	   success: function(msg){
		
		if (msg.length < 5) {
				$("#CreateSearchResults").hide();
		} else {
		
			$("#RenderContent").animate({opacity:.3},300)
				$("#CreateSearchResults").show();
				
				$("#RenderCreateSearchResults").html(msg)
		   }
		}
	});
}



function closeCreateSearch() {
	$("#CreateSearchResults").hide();
	$("#RenderContent").animate({opacity:1},200)
}


function createChallenge() {

	value = $("#challenge_title").val();
	
	if (value.length < 5) {
		$("#challenge_title").focus();
	} else {
		
		
		$("#CreateContent").html('<img style="margin-top:4px;" src="/images/ajax-loader_f.gif">');
		
		$.ajax({
		   type: "POST",
		   url: "/challenges",
		   data: 'challenge[lat]=0&challenge[lng]=0&challenge[city]=99&challenge[title]='+value,
		   success: function(msg){
				
			$("#RenderContent").prepend(msg)
			$("#Arrow").hide();
			$("#CreateContent").html('Create');
			$("#challenge_title").val('')
			$("#CharacterCount").hide();
			$("#challenge_title").focus();
			closeCreateSearch();
			updateNote('created',1)
		   }
		});
	}
}

function submitChallengeOnEnter(myfield,e,type)
{
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
else return true;

if (keycode == 13)
   {
	createChallenge();
	
   return false;
   }
else
   return true;
}


function openShareModal(layer) {

	if ($(layer).is(':visible')) {
		$(layer).parent().parent().parent().css("margin-bottom","30px")
		$(layer).hide();
	} else {
		$(layer).parent().parent().parent().css("margin-bottom","12px")
		$(layer).show();	
	}
	

}


function openAchievements(id) {
	selectedChallenge = id;
	$("#RenderAchievements").show();
	$("#BlackModal").show();
	$("#BlackModal").css('z-index',90);
	$("#BlackModal").animate({opacity: .4,}, 100 );
	$("#BlackModal").height($(document).height())

	$.get("/achievements", { }, function(theResponse){
		$('#RenderAchievements').html(theResponse);
		setTimeout("$('#achievement_name').focus();",100);
	});
}

function replaceAchievement(img,a_id) {
	$("#Achievement_"+selectedChallenge).attr('src',$(img).attr('src'));
	
	$.ajax({
       type: "POST",
       url: "/challenges/"+selectedChallenge,
       data: "_method=PUT&challenge[achievement_id]=" + a_id,
       success: function(msg){
		$("#draftTag").hide();
		draftTag = 0;
		resetPublish()
       }
    });
	
	closeRegister();
}

function publishChallenge(a_id) {

	$("#publishButtonText").html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
	
	$.ajax({
       type: "POST",
       url: "/challenges/"+a_id,
       data: "_method=PUT&challenge[published]=1",
       success: function(msg){
		$("#PublishLayer").hide();
		
		$("#ShareMyPublished").show();
       }
    });
	
	
	
}



function resetPublish() {

}


function liveAchSearch(input) {
	$.ajax({
	   type: "POST",
	   url: "/achievement_live_results",
	   data: 'search_text='+$(input).val(),
	   success: function(msg){
			$("#Ach_LiveResults").html(msg)
	   }
	});
}

function createAchievement(button,value) {
	if (value.length > 2) {
		button2=$(button)
		$(button).html('<img style="margin-top:3px;" src="/images/ajax-loader_f.gif">');
		$.ajax({
		   type: "POST",
		   url: "/achievements",
		   data: 'achievement[name]='+value+'&challenge_id='+selectedChallenge,
		   success: function(msg){
				$(button2).html('Add');
				eval(msg)
				if (created == 0) {
					replaceAchievement($("#a_img_"+ach_id),ach_id)
				} else {
					uploadAchievement(ach_id)
				}
		   }
		});
	} else {
		$('#achievement_name').focus();
	}
	
}



function submitAchOnEnter(myfield,e)
{
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
else return true;

if (keycode == 13)
   {
	createAchievement($('#AchAdd'),$('#achievement_name').val())
   return false;
   }
else
   return true;
}



function ApplyReward(value) {
	value = value.toLowerCase();
	
	if (value=='stompvip') {
		ReducePriceBy(0,1)
		return;
	}
	
	if (value=='urbaninteractive') {
		ReducePriceBy(20,2)
		return;
	}
	
	if (value=='mongoose') {
		ReducePriceBy(20,2)
		return;
	}
	if (value=='joinme42') {
		ReducePriceBy(.90,1)
		return;
	}
	
	alert('invalid code')
	
}

function ReducePriceBy(amount,type) {
	if (type == 1) { //percent
		newprice = $('#unit_price').val() * amount;
	} else { //dollar amount
		newprice = $('#unit_price').val() - amount;	
	}
	
	$('#unit_price').val(newprice);
	price = newprice * qty;
	$('.price_display').html('$'+roundNumber($('#unit_price').val()*qty,2))
	$(".RewardDiv").html('Discount Applied')
	
	$(".buyticket").html('Buy Ticket - $'+roundNumber(newprice,2));
	
}


function switchUser(id) {
	window.location.href = "/admin?user_id="+id
}

function adjustLoginLayer() {
	left = $("#LoginButton2").offset().left-90; 
	$("#LoginLayer").css("left",left+"px")
}

function adjustWindowSize() {
	
	
	
	
	if ($(window).height() > 600) {
		margt = $(window).height()-51-40-330+24;
		$("#home_info_container").css("margin-top",margt)
	}
	
	topInfo = parseInt($("#home_info_container").css("margin-top"))+55+340;
	if ($(window).height() < topInfo) {
		$('#big_image_background').css('height', topInfo+'px');
		footer_h =topInfo;
	} else {
		$('#big_image_background').css('height', $(window).height()-51);
		footer_h = $(window).height()-25;
	}
 


	$('#Home_Footer').css("top",footer_h+"px");
	
	left = ($(window).width()-220) /2	
	$("#spinner").css("left",left+"px")
}


function clearButton(button) {
	$(button).css('text-align','center')
	$(button).html('<img src="/images/ajax-loader_f.gif">')
}
function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}
function nextPlan(offset) {
	
	plan_index = plan_index+offset;
	

	if (plan_index + 1> plans.length || !plans.length) {
		plan_index = plan_index - offset;
		openRegister('Sign up for Escapist!');
		return;
	}
	
	
	if (plans.plan != null) {
		current_plan = plans.plan
	} else {
		current_plan = plans[plan_index].plan;
	}
	
	backButton = 0;
	setTimeout("backButton = 1",100)
	
	//calls loadinfo through history binding
	if (start !=1) {
		if (History.enabled) {
	 		History.pushState({id:current_plan.id}, null, "?id="+current_plan.id);
		} else {

			
			//$('#big_image_background').css("opacity",".2")
			loadInfo(plan_index);
			
			
			$('#big_image_background').animate({
				opacity: .2,
			}, 200, function() {
				loadInfo(plan_index);
			
				//$('#big_image_background').animate({opacity: 1}, 250);
			} );
		}
	}
	
	
	
	
}


function loadInfo(index) {
	$("#MoreAttendees").hide();
	
	start = 0;
	if (plan_index == 0) {
		$("#prevarrow").hide();
		$(".home_slogan").show();
	} else {
		$("#prevarrow").show();
		$(".home_slogan").hide();
	}
	
	if (plans.plan != null) {
		current_plan = plans.plan
	} else {
		current_plan = plans[plan_index].plan;
	}
	
	if (plans.length-1 > plan_index) {
		next_plan = plans[plan_index+1].plan;
	}
	plan_id = current_plan.id
	$('#plan_title').html(current_plan.title);
	$('#plan_url_name').html(current_plan.short_location);
	
	if (group == 0) {
		note = current_plan.short_desc
	} else {
		note = current_plan.note
		setTimeout("$('.multiline').ellipsis();",500);
	}
	if (note.length > 300) {
		note = note.substring(0, 300)
	}
	$('#plan_note').html(note);
	

	
	//
	
	
	if(current_plan.application_required) {
		html = '<div style="text-align:center">Apply Now!</div>'
	} else {
		html = '<div class="BuyIcon"></div>'
		html = html +'<div id="plan_price" style="position:absolute; margin-left:50px;"></div>'
	}
	$(".home_buy_button").html(html)
	if (current_plan.price) {
		string_price = ''+current_plan.price+''
		string_price = string_price.replace('.0','');
		$('#plan_price').html('$'+string_price);
    } else {
		$('#plan_price').html('FREE');
	}
	
	
	//start_time = new Date(current_plan.start_time);
	
	str=current_plan.start_time.split('-');
	var start_time=new Date();
	start_time.setUTCFullYear(str[0], str[1]-1, str[2]);
	start_time.setUTCHours(0, 0, 0, 0);
	
	month_index = start_time.getUTCMonth()+1;
	month = getShortMonth(month_index);
	day = start_time.getUTCDate()
	year  = str[0];
	 currentTime = new Date()
	 thisYear = currentTime.getFullYear();
	$('#plan_startdate_month').html(month);
	
	if (year > thisYear ) {
		$('#plan_startdate_day').html(year);
	} else {
		$('#plan_startdate_day').html(day);
	}

	if (plans.length-1 > plan_index) {
		$('#next_plan_link').show();
		$('#next_arrow').show();
		//new_start_time = new Date(next_plan.start_time);
		
		str=next_plan.start_time.split('-');
		var new_start_time=new Date();
		new_start_time.setUTCFullYear(str[0], str[1]-1, str[2]);
		new_start_time.setUTCHours(0, 0, 0, 0);
		
		
		new_month_index = new_start_time.getUTCMonth()+1;
		new_month = getShortMonth(month_index).toLowerCase();
		new_month = new_month.charAt(0).toUpperCase() + new_month.charAt(1) + new_month.charAt(2);
		new_day = new_start_time.getUTCDate()
		$('#next_plan_link').html(next_plan.title+' on '+new_month+' '+new_day);
	} else {
		
		if (loggedIn == 0) {
			$('#next_plan_link').html('Sign up to learn about new events')
		} else {
			$('#next_plan_link').hide();
			$('#next_arrow').hide();
		}
	//	$('#next_plan_link').hide();
	//	$('#next_arrow').hide();
	}
	
	

	
	
	
	$("#plan_signup_count").html(current_plan.users.length+1);
	if (current_plan.users.length+1 == 1) {
		$("#plan_signup_words").html("sign-up");
	} else {
		$("#plan_signup_words").html("sign-ups");
	}
	
	//html = '<a href="/'+current_plan.user.username+'"><img alt="" class="Transparent tl paddingA" src="http://assets.stomp.io/avatars/'+current_plan.user.id+'/thumb_50_'+current_plan.user.avatar_file_name+'" title="'+current_plan.user.first_name+'" style="width:50px; height:50px; border:1px solid #E1E1E1; cursor:pointer; float:left; margin-left:-1px;" /></a>'
		
	

	
	organizer_count = 0;
	signup_count = 0;
	total_count = 0;
	hosts = ''
	html = ''
	host_names = ''
	for (var i = 0; i < current_plan.organizers.length; i++) {
			the_user = current_plan.organizers[i];
		if (the_user.avatar_file_name != null) {
			if (organizer_count < 5) {
				transition =''
				if (organizer_count == 0) {
					
				} else {
					if (organizer_count == 4 || organizer_count+1 == current_plan.organizers.length) {
						transition ='& '
					} else {
						transition =', '
					}
				}
				host_names = host_names + ' '+transition+'<a class="LightLink" href="/'+the_user.username+'">'+the_user.first_name+'</a>'
				hosts = hosts+'<a href="/'+the_user.username+'"><img alt="" class="Transparent tl paddingA" src="http://assets.stomp.io/avatars/'+the_user.id+'/thumb_50_'+the_user.avatar_file_name+'" title="'+the_user.first_name+'" style="width:50px; height:50px; border:1px solid #E1E1E1; cursor:pointer; float:left; margin-left:-1px;" /></a>'
			}
			organizer_count = organizer_count + 1;
		} 
	}
	
	total_count = organizer_count;
	
	
	html = hosts;
	for (var i = 0; i < current_plan.users.length; i++) {
			the_user = current_plan.users[i];
		if (the_user.avatar_file_name != null) {
			if (total_count < 5) {
				html = html+'<a href="/'+the_user.username+'"><img  class="Transparent tl paddingA" src="http://assets.stomp.io/avatars/'+the_user.id+'/thumb_50_'+the_user.avatar_file_name+'" title="'+the_user.first_name+'" style="width:50px; height:50px; border:1px solid #E1E1E1; cursor:pointer; float:left; margin-left:-1px;" /></a>'
			}
			signup_count = signup_count + 1;
			total_count = total_count + 1;
			
		} else {
		//	html = html+'<a href="/'+the_user.username+'"><img alt="" class="Transparent" src="/images/no_avatar.png?1263875148" style="width:50px; height:50px; border:1px solid #E1E1E1; cursor:pointer; float:left; margin-left:-1px;" /></a>'
		}
	}
	
	
	if (signup_count < 2) {
		$("#plan_signup_count").html('')
		$("#plan_signup_words").html("Hosted by "+host_names)
		the_user = current_plan.user;
		$("#plan_attendees").html(hosts)
		//html = '<a href="/'+the_user.username+'"><img alt="" class="Transparent tl paddingA" src="http://assets.stomp.io/avatars/'+the_user.id+'/thumb_50_'+the_user.avatar_file_name+'" title="'+the_user.first_name+'" style="width:50px; height:50px; border:1px solid #E1E1E1; cursor:pointer; float:left; margin-left:-1px;" /></a>'
		//html = html + '<div style="margin-left:5px; float:left; font-size:12px">'+the_user.first_name+' '+the_user.last_name +'</div>';
	} else {
		$("#plan_attendees").html(html)
	}
	
	//html = html + "<script>$('.tip').tooltip();</script>"
 
	//setTimeout(" $('.tl').tooltip();",1000)
	if (total_count > 4)	{
		$("#MoreAttendees").show();
	}
	

	
	
	
	
	
	
	//if (plans.length < 2) {
	//	$('.home_info_next').hide();
	//} else {
	//	$('.home_info_next').show();
	//}
	
	if (plans.length < 2 || !plans.length) {
		$("#viewall1").hide();
		$("#viewall2").hide();
		
		if (loggedIn == 1) {
			$('.home_info_next').hide();
		}
	} else {
		$("#viewall1").show();
		$("#viewall2").show();
		$('.home_info_next').show();
	}
	
	image_url = "http://assets.stomp.io/images/"+current_plan.id+"/thumb_1250_"+current_plan.image_file_name
	switchPhoto(image_url);
	
	

	
}


function switchPhoto(image_url) {
	$('#big_image_background').css('background', 'url('+image_url+')');
	$('#big_image_background').css('background-size', 'cover');
	
	var img = new Image();
	$(img).load(function(){
	      //When image is loaded
	      
				$('#big_image_background').animate({opacity: 1}, 250);
	}).attr("src", image_url);
	
	
		
//	$('#hideImage').attr('src', image_url).load(function() {
//		alert('ho')
//		$('#big_image_background').animate({opacity: 1}, 500);
//	} );
}


function getShortMonth(month_index) {
	month = ""
	if (month_index == 1) { month = "JAN"}
	if (month_index == 2) { month = "FEB"}
	if (month_index == 3) { month = "MAR"}
	if (month_index == 4) { month = "APR"}
	if (month_index == 5) { month = "MAY"}
	if (month_index == 6) { month = "JUN"}
	if (month_index == 7) { month = "JUL"}
	if (month_index == 8) { month = "AUG"}
	if (month_index == 9) { month = "SEP"}
	if (month_index == 10) { month = "OCT"}
	if (month_index == 11) { month = "NOV"}
	if (month_index == 12) { month = "DEC"}
	return month;
}

function refresh_home(json) {
	plan_index = 0;
	plans = json;

	if (plans.plan != null) {
		current_plan = plans.plan
	} else {
		current_plan = plans[plan_index].plan;
	}
	
    skip=1;

	if (History.enabled) {
		plan_index = 0;
		backButton = 0;
		setTimeout("backButton = 1",100)
 		History.pushState({id:current_plan.id}, null, "?id="+current_plan.id);

	} else {

		$('#big_image_background').animate({
			opacity: .1,
		}, 200, function() {
			loadInfo(plan_index);

			//$('#big_image_background').animate({opacity: 1}, 250);
		} );
	}
		//switchPhoto();
	$('#spinner').hide();
	skip = 0;
//	$('#big_image_background').animate({opacity: 1}, 250);
}


preload_image_index=0;
function preloadImage() {

	preload_image_index = preload_image_index +1;
	preload_plan = plans[preload_image_index].plan;
	
	image_url = "http://assets.stomp.io/images/"+preload_plan.id+"/thumb_1250_"+preload_plan.image_file_name
	
	var img = new Image();
	$(img).load(function(){
	      preloadImage();
	}).attr("src", image_url);
}

function iconWhite(type) {
	$("#"+type).removeClass(type).addClass(type+"_h")
}
function iconBlue(type) {
	$("#"+type).removeClass(type+"_h").addClass(type)
}
function setAnimate(row) {
	$(row).css("text-align","center")
	$(row).html('<img src="/images/ajax-loader_f.gif">')
}






function slideOverview() {
	$("#applyNowLayer")
            .animate(
              { left: "200%",  }, {
                duration: 1500,
                easing: 'easeOutBack'
              });
				$("#faqLayer")
			            .animate(
			              { left: "100%",  }, {
			                duration: 1500,
			                easing: 'easeOutBack'
			              });

	$("#learnMoreLayer")
            .animate(
			        { left: "0%",  }, {
			          duration: 1500,
			          easing: 'easeOutBack'
	            });
	
				$('.learn-more').addClass('mainLinkActive');
								$('.faq-link').removeClass('mainLinkActive');
					$('.apply-now').removeClass('mainLinkActive');
					
					height = $("#learnMoreLayer").height()
					$("#maincontainer").css("height",height+20)
}

function slideFaq() {
	$("#applyNowLayer")
            .animate(
              { left: "200%",  }, {
                duration: 1500,
                easing: 'easeOutBack'
              });
			$("#learnMoreLayer")
		            .animate(
		              { left: "-100%",  }, {
		                duration: 1500,
		                easing: 'easeOutBack'
		              });


	$("#faqLayer")
            .animate(
			        { left: "0%",  }, {
			          duration: 1500,
			          easing: 'easeOutBack'
	            });
	
				$('.learn-more').removeClass('mainLinkActive');
								$('.faq-link').addClass('mainLinkActive');
					$('.apply-now').removeClass('mainLinkActive');
					
					height = $("#faqLayer").height()
					$("#maincontainer").css("height",height+20)
					
}

function slideApp() {

	$("#learnMoreLayer")
            .animate(
              { left: "-100%",  }, {
                duration: 1500,
                easing: 'easeOutBack'
              });
				$("#faqLayer")
			            .animate(
			              { left: "-100%",  }, {
			                duration: 1500,
			                easing: 'easeOutBack'
			              });

	$("#applyNowLayer")
            .animate(
              { left: "100%",  }, {
                duration: 1500,
                easing: 'easeOutBack'
              });


			height = $("#applyNowLayer").height()
			$("#maincontainer").css("height",height+20)
			


$('.learn-more').removeClass('mainLinkActive');
				$('.faq-link').removeClass('mainLinkActive');
	$('.apply-now').addClass('mainLinkActive');
	
}


function goToByScroll(id){
      $('html,body').animate({scrollTop: $("#"+id).offset().top},'slow');
}



