// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import SimpleMDE from "simplemde"
import hljs from "highlight.js"

hljs.initHighlightingOnLoad();

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
function getCsrfToken() {
  return $("#csrf-token").data("csrfToken");
}

$("#topic-selector .topic-list .name a").bind({
  click: function() {
    var topic_id = $(this).closest("span").data("id");
    $(".selected-topic").html($(this).text())
    $("#post_topic_id").val(topic_id);
    $('#topic-selector').modal('toggle');
  }
})

// 编辑器
if($("#editor")[0]) {
  var simplemde = new SimpleMDE({
    element: $("#editor")[0],
    lineWrapping: false,
    parsingConfig: {
      allowAtxHeaderWithoutSpace: true,
      strikethrough: false,
      underscoresBreakWords: true,
    },
    renderingConfig: {
      singleLineBreaks: false,
      codeSyntaxHighlighting: true,
    },
    showIcons: ["code", "table"],
    spellChecker: false,
    status: false
  })
}

// 退出登录
$("#logout").bind({
  click: function() {
    $.ajax({
      url: `/api/sessions/${$(this).data("userId")}`,
      data: {
        _csrf_token: getCsrfToken()
      },
      method: "DELETE",
      success: function(data) {
        window.location.reload();
      }
    })
  }
})

var file = {};
$("#upload-submit").bind({
  click: function() {
    console.log($("#upload-form").serialize())
  /**
  $("#upload-form").ajaxSubmit(function(data) {
    alert(data);
  })
  **/
   $.ajax({
    url: "/api/images",
    method: "POST",
    datatype: "JSON",
    data: $("#upload-form").serialize(),
   // data: {
   //   _csrf_token: getCsrfToken(),
   //   upload: {
   //     file: {
   //       path: file.path,
   //       filename: file.name,
   //       content_type: file.type
   //     }
   //   }
   // },
    success: function(data) {
      console.log(data)
      return false;
    }
   })
  return false;
  }
})
