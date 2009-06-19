// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// More behaviours
function check_read(read) {
  $(".message_toggle").each(function() {
    if ($(this).parents(".read").length) {
      $(this).attr("checked", read);
    }
    else if ($(this).parents(".unread").length) {
      $(this).attr("checked", !read);
    }
  });
}

function remove_contact_item() {
  $(this).siblings(".delete").val(1);
  $(this).parents("p").hide();
  return false;
}

$(document).ready(function() {
  // contacts
  $("#contact .add").click(function() {
    link = $(this);
    $.get(link.attr("href"), function(page) {
      link.parents("fieldset").append(page);
    });
    return false;
  });

  $("#contact .remove").live("click", remove_contact_item);

  // settings
  $(".signature .on textarea").click(function() {
    $(".signature .on input[type=radio]").attr("checked", true);
  });

  $(".signature .on input[type=radio]").click(function() {
    $(".signature .on textarea").focus();
  });

  // email composition
  $("#add_attachment").click(function() {
    $.get($(this).attr("href"), function(page) {
      $("#attachments").append(page);
    });
    return false;
  });

  // mailbox list ajax
  $("#selection #all").click(function() {
    $(".message_toggle").attr("checked", true)
    return false;
  });

  $("#selection #none").click(function() {
    $(".message_toggle").attr("checked", false)
    return false;
  });

  $("#selection #read").click(function() {
    check_read(true);
    return false;
  });

  $("#selection #unread").click(function() {
    check_read(false);
    return false;
  });

  $("#selection #inverse").click(function() {
    $(".message_toggle").each(function(index, elem) {
      elem.checked = !elem.checked;
    });
    return false;
  });

  $("p.attachment input").live("change", function() {
    //ajax upload image here
  });

  $("p.attachment a.remove").live("click", function() {
    $(this).parent().remove();
    return false;
  });

  $("a.destroy").live("click", function() {
    $("<form method='post' action='" + this.href + "' />")
    .append("<input type='hidden' name='authenticity_token' value='" + AUTH_TOKEN + "' />")
    .append("<input type='hidden' name='_method' value='delete' />")
    .appendTo("body").submit();
    return false;
  });
});
