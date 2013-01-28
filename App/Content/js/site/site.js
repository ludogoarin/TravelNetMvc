
$(function () {

    // language switcher
    setLanguageSwitcher();

    // search form
    setSearchForm();

    // Trip tabs
    loadProductTabs();

    // Load auto-presets
    loadAutos();

    // validate forms
    validateForms();

    // load auto classes
    autoClasses();
});

$(window).bind('load', function () {
    // set auto slideshows
    loadSlideshows();

    // set left column height
    setDimensions();
});

function addToFavorites() {
    title = document.title;
    // Blogger - Replace with <$BlogItemTitle$> 
    // MovableType - Replace with <$MTEntryTitle$>

    url = window.location.href;
    // Blogger - Replace with <$BlogItemPermalinkURL$> 
    // MovableType - Replace with <$MTEntryPermalink$>
    // WordPress - <?php bloginfo('url'); ?>

    if (window.sidebar) { // Mozilla Firefox Bookmark
        window.sidebar.addPanel(title, url, "");
    } else if (window.external) { // IE Favorite
        window.external.AddFavorite(url, title);
    }
    else if (window.opera && window.print) { // Opera Hotlist
        return true;
    }
}

function emailPage() {
    window.location.href='mailto:?subject=' + encodeURIComponent(document.title) + '&body=' + encodeURIComponent(document.title + ': ' + window.location.href);
}

function autoClasses() {
    $("input, select, textarea").focus(function () {
        $(this).addClass("focus");
    });
    $("input, select, textarea").blur(function () {
        $(this).removeClass("focus");
    });
}

function loadAutos() {

    // Date picker
    $.datepicker.setDefaults($.datepicker.regional['fr']);
    $("input.datepicker").each(function () {
        $(this).datepicker($.datepicker.regional['fr']);
    });

    $("#bt_email_signup").click(function () {
        postEmailSignupForm();
    });
}

function validateForms() {
    $("form").each(function () {
        $(this).validate();
    });
}

function loadSlideshows() {
    $('.quick-slideshow').cycle({
        fx: 'fade', // choose your transition type, ex: fade, scrollUp, shuffle, etc...
        cleartype: 1 // enable cleartype corrections 
    });


    // jCycle - Home Slideshow
    $('#home_slideshow ul.slides').cycle({
        fx: 'fade',
        //speed:  '600',
        timeout: 3000,
        pager: 'div.pages',
        cleartype: 1 // enable cleartype corrections 
    });

    $(".cursor a.previous").click(function () {
        $('#home_slideshow ul.slides').cycle("prev");
    });

    $(".cursor a.next").click(function () {
        $('#home_slideshow ul.slides').cycle("next");
    });

}

function setDimensions() {
    var contentHeight = $("div.2column-content").height();
    $("div.left-column-content").height(contentHeight);
}

function toggleLanguageSwitcher(show) {
    var switcher = $("#language_switcher");
    if (show == true) {
        switcher.fadeIn("fast");
    } else {
        switcher.fadeOut("fast");
    }
}

function showHideLanguageSwitcher(show) {
    var switcher = $("#language_switcher");
    if (show == true) {
        switcher.show();
    } else {
        switcher.hide();
    }
}

function setLanguageSwitcher() {
    var switchBlock = $("#language_switcher_container");
    var swicthOptions = $("#language_switcher");

    switchBlock.mouseenter(function () {
        toggleLanguageSwitcher(true);
    });

    switchBlock.mouseleave(function () {
        toggleLanguageSwitcher(false);
    });
}

function setSearchForm() {
    // cheval et autrement
    $("#product_search_form").submit(function () {
        var filter_Tag = $("#tag").val();
        var filter_profile = $("#profile").val();
        var filter_destination = $("#destination").val();
        var filter_budget = $("#budget").val();
        var filter_departure = $("#departure").val();
        var filter_activity = $("#activityId").val();
        var qstring = "";

        filter_Tag = filter_Tag == "" ? "all" : "/" + filter_Tag;
        filter_destination = filter_destination == "" ? "" : "/" + filter_destination;

        filter_budget = "budget=" + (filter_budget == "" ? "" : filter_budget);
        filter_departure = "&dep=" + (filter_departure == "" ? "" : filter_departure);
        filter_activity = "&activityId=" + (filter_activity == "" ? "" : filter_activity);
        filter_profile = "&profile=" + (filter_profile == "" ? "" : filter_profile);
        qstring = "?" + filter_budget + filter_departure + filter_activity + filter_profile;

        window.location.href = "/voyage/search" + filter_Tag + filter_destination + qstring;
        return false;
    });

    // destinations
    $("#product_search_destinations_form").submit(function () {
        var filter_Tag = $("#profile").val();
        var filter_destination = $("#destination").val();
        var filter_activity = $("#activity").val();
        var filter_budget = $("#budget").val();
        var filter_departure = $("#departure").val();
        var qstring = "";

        // url segments
        filter_activity = filter_activity == "" ? "all" : "/" + filter_activity;
        filter_destination = filter_destination == "" ? "/all" : "/" + filter_destination;

        // query string
        filter_budget = "budget=" + (filter_budget == "" ? "" : filter_budget);
        filter_departure = "&dep=" + (filter_departure == "" ? "" : filter_departure);
        filter_Tag = "&tag=" + (filter_Tag == "" ? "all" : filter_Tag);
        //filter_budget = ((filter_departure == "") || (filter_budget == "")) ? filter_budget : filter_budget + "&";
        qstring = "?" + filter_budget + filter_departure + filter_Tag;

        // full url
        window.location.href = "/voyage/destinations" + filter_destination + filter_activity + qstring;
        return false;
    });

    // homepage
    $("#product_search_home_form").submit(function () {
        var filter_Tag = $("#profile").val();
        var filter_destination = $("#destination").val();
        var filter_budget = $("#budget").val();
        var filter_departure = $("#departure").val();
        var filter_activity = $("#activityId").val();
        var qstring = "";

        //filter_Tag = filter_Tag == "" ? "/all" : "/" + filter_Tag;
        filter_Tag = filter_Tag == "" ? "" : "&tag=" + filter_Tag;
        filter_destination = filter_destination == "" ? "" : "/" + filter_destination;

        if ((filter_budget != "") || (filter_departure != "")) {
            filter_budget = filter_budget == "" ? "" : "budget=" + filter_budget;
            filter_departure = filter_departure == "" ? "" : "dep=" + filter_departure;
            filter_activity = filter_activity == "" ? "" : "&activityId=" + filter_activity;
            filter_budget = ((filter_departure == "") || (filter_budget == "")) ? filter_budget : filter_budget + "&";
            qstring = "?" + filter_budget + filter_departure + filter_activity;
        }
        qstring = qstring.length > 0 ? qstring + filter_Tag : "?" + filter_Tag;

        //window.location.href = "/voyage/search" + filter_Tag + filter_destination + qstring;
        window.location.href = "/voyage/destinations" + filter_destination + qstring;
        return false;
    });

}


// Trip Gallery
function loadTripImg(imgSrc, caller) {
    $(".product-thumb").removeClass("active");
    $(caller).addClass("active");
    var imgResizerFormat = "/img/view?path=/content/trip-photos/{0}&width=710&height=500";
    var fullImgSrc = String.format(imgResizerFormat, imgSrc);
    $(".product-detail-images .full-view img").attr("src", fullImgSrc);
}

// Trip tabs
function loadProductTabs() {
    $("#product_tabs").tabs();
}

// Share
function shareFacebook() {
    window.open('http://www.facebook.com/sharer.php?u=' + encodeURIComponent(location.href) + '&amp;t=' + encodeURIComponent(document.title), 'facebook', 'toolbar=no,width=550,height=550');
    return false;
}

function shareDelicious() {
    window.open('http://delicious.com/save?v=5&amp;noui&amp;jump=close&amp;url=' + encodeURIComponent(location.href) + '&amp;title=' + encodeURIComponent(document.title), 'delicious', 'toolbar=no,width=550,height=550');
    return false;
}

function shareTwitter() {
    window.open('http://twitter.com/home?status=' + encodeURIComponent('Caval &amp; go -  ' + document.title + ' - ' + location.href), 'twitter', 'toolbar=no,width=550,height=550');
    return false;
}

function shareMySpace() {
    window.open('http://www.myspace.com/Modules/PostTo/Pages/?u=' + encodeURIComponent(document.location.toString()), 'ptm', 'height=450,width=440').focus();
    return false;
}


function postEmailSignupForm() {
    var visitor_email = $("#email_signup").val();
    $("#msg_email_signup").text("");
    if (visitor_email.length < 10) {
        $("#email_signup").addClass("error");
        $("#msg_email_signup").text("Adresse email invalide");
    } else {
        $("#email_signup").removeClass("error");
        $("#vmsg_email_signup").text("");
        $.post("/message/sendEmailForm", {
            action: "sendmail",
            subjectLine: "Caval&go Email Signup",
            redirectUrl: "",
            mailFrom: "no-reply@cavalandgo.com",
            mailTo: "contact@cavalandgo.com",
            'Visitor email': visitor_email
        },
		   function (data) {
		       emailSignupCallback(data);
		   });
    }
}

function emailSignupCallback(data) {
    if (data == "success|email sent") {
        $(".email-fields").html("Merci.");
    } else {
        alert("Veuillez vérifier votre addresse.");
    }
}
