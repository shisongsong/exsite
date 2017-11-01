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
$(".icon-reply, .reply-link").bind({
  click: function() {
    var replyForm = $(this).parents(".media-body").children(".reply-form");
    var reply_id = $(this).attr("data-reply-id");
    var replied_label = replyForm.find(".replied-label");

    replyForm.find("input[name='reply[reply_id]']").remove();

    // 判断被回复的是不是评论
    if(reply_id) {
      replyForm.append(
        "<input name='reply[reply_id]' type='hidden' value='" + reply_id + "' >");

      replied_label.
        find(".replied-nickname").
        html("回复："+$(this).data("userNickname"));
      replied_label.show();
      if(!replyForm.is(":visible")) replyForm.show();
    }
    else {
      replyForm.toggle();
    }
  }
})

$(".replied-label .glyphicon-remove").bind({
  click: function() {
    var replyForm = $(this).closest(".reply-form");
    var replied_label = $(this).closest(".replied-label");

    replyForm.find("input[name='reply[reply_id]']").remove();
    replied_label.find(".replied-nickname").html();
    replied_label.hide();
  }
})

// 提交回复
$(".reply-form").submit(function() {
  if($.trim($(this).find("textarea").val()).length > 0) {
    $.ajax({
      url: $(this).attr("action"),
      data: $(this).serialize(),
      method: "POST",
      success: function(data) {
      },
      error: function(res) {
      }
    });
  }
  else {
    var error_info = $(this).find(".error-info");
    error_info.html("内容不可为空").show();
    $(this).find("textarea").focus();
    setTimeout(function() {
      error_info.hide();
    }, 3000);
  }

  return false; // 使form的action跳转失效
})
