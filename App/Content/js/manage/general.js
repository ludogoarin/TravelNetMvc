$(function () {
    // set default action controls
    setActionControls();

    // validate forms
    validateForms();

    // load defaults
    loadDefaults();
});

function setActionControls() {
    $("a.delete_action").click(function () {
        return confirm("Are you sure you want to delete this item?");
    });

    $("select#translations_language_sel").change(function () {
        var selectedLanguageId = $(this).val();
        window.location.href = "/manage/translations?lg=" + selectedLanguageId;
    });
}

function loadDefaults() {
    
    // WYSIWYG
    $("textarea.wysiwyg").each(function () {
        loadGenericEditor($(this).attr('id'));
    });

    // Inline editing
    $('input.inline-edit').live('focusin', function () {
        $("a.inline-edit-save-button").removeClass("on");
        var itemId = $(this).attr('id');
        var indentifier = itemId.substr(itemId.indexOf("_") + 1);
        $("#inlineSaveBt_" + indentifier + " img").attr("src", "../../Content/images/admin/icons/bullet_disk.png");
        $("#inlineSaveBt_" + indentifier).addClass("on");
    });

    // Date picker
    $.datepicker.setDefaults($.datepicker.regional['fr']);
    $("input.datepicker").each(function () {
        $(this).datepicker($.datepicker.regional['fr']);
    });

    // File Manager Directory
    $("#filemanager_directory").change(function () {
        var newDir = $(this).val();
        fileManager_newDirectory(newDir);
    });

    // File Manager Directory
    $("#filemanager_directory_bt").click(function () {
        var newDir = $("#filemanager_directory").val();
        fileManager_newDirectory(newDir);
    });
}

function fileManager_newDirectory(newDir) {
    if (newDir != "void") {
        window.location.href = "/manage/files?dir=" + newDir;
    }
}

function setInlineSaveBtStatus(imgIdentifier, newStatus) {
    var btImg = $("#inlineSaveBt_" + imgIdentifier + " img");

    if (newStatus == "complete") {
        btImg.attr("src", "../../Content/images/admin/icons/tick.png");
    } else if (newStatus == "processing") {
        btImg.attr("src", "../../Content/images/admin/icons/ajax-loader.gif");
    } else if (newStatus == "reset") {
        btImg.attr("src", "../../Content/images/admin/icons/bullet_disk.png");
    }
}

function updateDestination(itemId) {
    var newName = $("#destinationName_" + itemId).val();
    setInlineSaveBtStatus(itemId, "processing");

    var updateDestination_Result = function (result) {
        setInlineSaveBtStatus(itemId, "complete");
    }

    var updateDestination_Error = function (xhr) {
        setInlineSaveBtStatus(itemId, "reset");
        if (xhr.responseText) {
            alert(xhr.responseText);
        } else {
            alert(xhr.get_message());
        }
        return;
    }

    postJSONtoMVC("/manage/destinations_update",
        { destinationId: itemId, updatedName: newName },
        updateDestination_Result,
        updateDestination_Error
    );
}

function updateDestinationAddress(itemId) {
    var newAddress = $("#destination_Address_" + itemId).val();
    setInlineSaveBtStatus("Address_" + itemId, "processing");

    var updateDestination_Result = function (result) {
        setInlineSaveBtStatus("Address_" + itemId, "complete");
    }

    var updateDestination_Error = function (xhr) {
        setInlineSaveBtStatus("Address_" + itemId, "reset");
        if (xhr.responseText) {
            alert(xhr.responseText);
        } else {
            alert(xhr.get_message());
        }
        return;
    }

    postJSONtoMVC("/manage/destinations_update_address",
        { destinationId: itemId, updatedAddress: newAddress },
        updateDestination_Result,
        updateDestination_Error
    );
}

function updateTag(itemId) {
    var newName = $("#tagName_" + itemId).val();
    setInlineSaveBtStatus(itemId, "processing");

    var updateTag_Result = function (result) {
        setInlineSaveBtStatus(itemId, "complete");
    }

    var updateTag_Error = function (xhr) {
        setInlineSaveBtStatus(itemId, "reset");
        if (xhr.responseText) {
            alert(xhr.responseText);
        } else {
            alert(xhr.get_message());
        }
        return;
    }

    postJSONtoMVC("/manage/tag_update",
        { ProductTagId: itemId, UpdatedName: newName },
        updateTag_Result,
        updateTag_Error
    );
}

function updateTagInfo(itemId) {
    var newName = $("#tagInfoName_" + itemId).val();
    setInlineSaveBtStatus(itemId, "processing");

    var updateTagInfo_Result = function (result) {
        setInlineSaveBtStatus(itemId, "complete");
    }

    var updateTagInfo_Error = function (xhr) {
        setInlineSaveBtStatus(itemId, "reset");
        if (xhr.responseText) {
            alert(xhr.responseText);
        } else {
            alert(xhr.get_message());
        }
        return;
    }

    postJSONtoMVC("/manage/tagInfo_update",
        { ProductTagInfoId: itemId, UpdatedName: newName },
        updateTagInfo_Result,
        updateTagInfo_Error
    );
}

function updateActivity(itemId) {
    var newName = $("#activityName_" + itemId).val();
    setInlineSaveBtStatus(itemId, "processing");

    var updateActivity_Result = function (result) {
        setInlineSaveBtStatus(itemId, "complete");
    }

    var updateActivity_Error = function (xhr) {
        setInlineSaveBtStatus(itemId, "reset");
        if (xhr.responseText) {
            alert(xhr.responseText);
        } else {
            alert(xhr.get_message());
        }
        return;
    }

    postJSONtoMVC("/manage/activity_update",
        { activityId: itemId, updatedName: newName },
        updateActivity_Result,
        updateActivity_Error
    );
}

function updateCmsPage(itemId) {
    var newName = $("#pageName_" + itemId).val();
    setInlineSaveBtStatus(itemId, "processing");

    var updateCmsPage_Result = function (result) {
        setInlineSaveBtStatus(itemId, "complete");
    }

    var updateCmsPage_Error = function (xhr) {
        setInlineSaveBtStatus(itemId, "reset");
        if (xhr.responseText) {
            alert(xhr.responseText);
        } else {
            alert(xhr.get_message());
        }
        return;
    }

    postJSONtoMVC("/manage/cms_page_update",
        { pageId: itemId, updatedName: newName },
        updateCmsPage_Result,
        updateCmsPage_Error
    );
}

function updateCmsBlock(itemId) {
    var newName = $("#blockName_" + itemId).val();
    setInlineSaveBtStatus(itemId, "processing");

    var updateCmsBlock_Result = function (result) {
        setInlineSaveBtStatus(itemId, "complete");
    }

    var updateCmsBlock_Error = function (xhr) {
        setInlineSaveBtStatus(itemId, "reset");
        if (xhr.responseText) {
            alert(xhr.responseText);
        } else {
            alert(xhr.get_message());
        }
        return;
    }

    postJSONtoMVC("/manage/cms_staticblock_update",
        { blockId: itemId, updatedName: newName },
        updateCmsBlock_Result,
        updateCmsBlock_Error
    );
}

function validateForms() {
    $("form").each(function () {
        $(this).validate();
    });
}

function ExtendTextarea(targetTextArea) {
    xtx.interpreter = new xtx.ShortcutInterpreter(new xtx.Editor(targetTextArea));
    xtx.interpreter.bind();
}

function toggleGenericEditor(textAreaId) {
    //var editor = $('#' + textAreaId).ckeditorGet();
    var editor = CKEDITOR.instances[textAreaId];
    if (editor) {
        var content = editor.getData();
        if (content == "<br />\n") editor.setData("");
        editor.destroy();
    } else {
        loadGenericEditor(textAreaId);
    }
}

function loadGenericEditor(textAreaId) {

    // load editor
    var editor = CKEDITOR.replace(textAreaId,
            {
                skin: 'kama',
                toolbar:
            [
                ['Source', '-', 'NewPage', 'Preview', '-', 'Templates'],
                ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Print', 'SpellChecker', 'Scayt'],
                ['Undo', 'Redo', '-', 'Find', 'Replace', '-', 'SelectAll', 'RemoveFormat'],
                ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],
                '/',
                ['Bold', 'Italic', 'Underline', 'Strike', '-', 'Subscript', 'Superscript'],
                ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', 'Blockquote'],
                ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'],
                ['Link', 'Unlink', 'Anchor'],
                ['Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak'],
                '/',
                ['Styles', 'Format', 'Font', 'FontSize'],
                ['TextColor', 'BGColor'],
                ['Maximize', 'ShowBlocks', '-', 'About']
            ]
            });

    editor.focus();
}

CKEDITOR.on('dialogDefinition', function (ev) {
    if (ev.data.name == 'image') {
        var btn = ev.data.definition.getContents('info').get('browse');
        btn.hidden = false;
        btn.onClick = function () { window.open(CKEDITOR.basePath + 'ImageBrowser.aspx', 'popuppage', 'scrollbars=no,width=780,height=630,left=' + ((screen.width - 780) / 2) + ',top=' + ((screen.height - 630) / 2) + ',resizable=no,toolbar=no,titlebar=no'); };
    }
    if (ev.data.name == 'link') {
        var btn = ev.data.definition.getContents('info').get('browse');
        btn.hidden = false;
        btn.onClick = function () { window.open(CKEDITOR.basePath + 'LinkBrowser.aspx', 'popuppage', 'scrollbars=no,width=520,height=580,left=' + ((screen.width - 520) / 2) + ',top=' + ((screen.height - 580) / 2) + ',resizable=no,toolbar=no,titlebar=no'); };
    }
});

function unloadGenericEditor(textAreaId) {
    var editor = $('#' + textAreaId).ckeditorGet();
    if (editor) {
        editor.destroy();
    }
}


function postJSONtoMVC(url, data, callback_success, callback_error) {
    $.ajax({
        type: "POST",
        url: url,
        data: data,
        success: callback_success,
        error: callback_error,
        dataType: "json"
    });
}

function switchlang_prodfulledit() {
    var url = location.href;
    var prodid = $("#ProductId").val();
    var newlangid = $("#CurrentLanguageId").val();

    window.location.href = prodid + "?lid=" + newlangid;
}

function deleteProductTab(tabId, productId, languageId) {
    if (confirm("Are you sure you want to delete this item?")) {
        window.location.href = "/manage/product_infotabs_delete?ProductInfoTabId=" + tabId + "&ProductId=" + productId + "&LanguageId=" + languageId;
    }
}





