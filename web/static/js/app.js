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

// 选择节点
$("#topic-selector .topic-list .name a").bind({
  click: function() {
    var topic_id = $(this).closest("span").data("id");
    $(".selected-topic").html($(this).text())
    $("#post_topic_id").val(topic_id);
    $('#topic-selector').modal('toggle');
  }
})

var simplemde;
// 编辑器
if($(".simplemde")[0]){
  simplemde = new SimpleMDE({
    element: $(".simplemde")[0],
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


$(".file-input").bind({
  change: function(e) {
    var file = e.target.files[0] || e.dataTransfer.files[0];
    var data = new FormData;
    data.append("upload[file]", file);
    $.post({
      url: "/api/images",
      data: data,
      contentType: false,
      processData: false
    }).done(function(data) {
      drawImageWithUrl(simplemde, data.url);
    }).fail(function(data) {
      console.log(data);
    })
  }
})

// 插入图片url
var drawImageWithUrl = function (editor, url) {
  var cm = editor.codemirror;
  var stat = editor.getState(cm);
  _replaceSelection(cm, stat.link, ["![](", "#url#)"], url);
}

function _replaceSelection(cm, active, startEnd, url) {
  if(/editor-preview-active/.test(cm.getWrapperElement().lastChild.className))
    return;

  var text;
  var start = startEnd[0];
  var end = startEnd[1];
  var startPoint = cm.getCursor("start");
  var endPoint = cm.getCursor("end");
  if(url) {
    end = end.replace("#url#", url);
  }
  if(active) {
    text = cm.getLine(startPoint.line);
    start = text.slice(0, startPoint.ch);
    end = text.slice(startPoint.ch);
    cm.replaceRange(start + end, {
      line: startPoint.line,
      ch: 0
    });
  } else {
    text = cm.getSelection();
    cm.replaceSelection(start + text + end);

    startPoint.ch += start.length;
    if(startPoint !== endPoint) {
      endPoint.ch += start.length;
    }
  }
  cm.setSelection(startPoint, endPoint);
  cm.focus();
}

// Toggle reply form 
$(".reply-link").bind({
  click: function() {
    var replyForm = $(this).closest(".comment-action").next("form");
    replyForm.toggle();
  }
})

// submit reply
$(".reply-submit").bind({
  click: function() {
    var form = $(this).closest("form");
    $.ajax({
      url: $(this).data("action"),
      data: {
        _csrf_token: getCsrfToken(),
        reply: {
          content: form.find("textarea").val()
        }
      },
      method: "POST",
      success: function(data) {
        console.log(data)
      },
      error: function(result) {
        console.log(result)
      }
    });
  }
})
