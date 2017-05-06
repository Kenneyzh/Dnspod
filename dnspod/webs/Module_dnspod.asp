<title>软件中心 - DNSpod</title>
<content>
<script type="text/javascript">
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/dnspod_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsup = E('_dnspod_up').value;
    if(dnsup == 1){
        $(E('_dnspod_interval')).prop('disabled', true);
    }else{
        $(E('_dnspod_interval')).prop('disabled', false);
    }
	return 1;
}
function save(){
	Apps.dnspod_enable = E('_dnspod_enable').checked ? '1':'0';
	Apps.dnspod_ak = E('_dnspod_ak').value;
	Apps.dnspod_sk = E('_dnspod_sk').value;
	Apps.dnspod_up = E('_dnspod_up').value;
	Apps.dnspod_interval = E('_dnspod_interval').value;
	Apps.dnspod_domain = E('_dnspod_domain').value;
	Apps.dnspod_dns = E('_dnspod_dns').value;
	Apps.dnspod_curl = E('_dnspod_curl').value;
	//Apps.dnspod_ttl = E('_dnspod_ttl').value;
	if(Apps.dnspod_ak == "" || Apps.dnspod_sk == "" || Apps.dnspod_domain == "ex.example.com" || Apps.dnspod_domain == ""){
		alert("信息填写不完整，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'dnspod_config.sh', "params":[], "fields": Apps};
	var success = function(data) {
		//
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);

		//  do someting here.
		//
	};
	var error = function(data) {
		//
		//  do someting here.
		//
	};
	$('#footer-msg').text('保存中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  error: error,
	  dataType: "json"
	});
	
	//-------------- post Apps to dbus ---------------
}
</script>
<div class="box">
<div class="heading">DNSpod <a href="javascript:history.back()" class="btn" style="float:right;border-radius:3px;">返回</a></div>
<br><hr>
<div class="content">
<div id="dnspod-fields"></div>
<script type="text/javascript">
var upoption_mode = [['1', 'WAN UP'], ['2', '周期性检查']];
var option_mode = [['1', 'whatismyip.akamai.com'], ['2', 'WAN'], ['3', 'WAN2'], ['4', 'WAN3'], ['5', 'WAN4'], ['6', 'ip.chinaz.com']];
$('#dnspod-fields').forms([
{ title: '开启DNSpod', name: 'dnspod_enable', type: 'checkbox', value: ((Apps.dnspod_enable == '1')? 1:0)},
{ title: '运行状态', name: 'dnspod_last_act', text: Apps.dnspod_last_act ||'--' },
{ title: 'Token ID', name: 'dnspod_ak', type: 'text', maxlen: 34, size: 34, value: Apps.dnspod_ak },
{ title: 'Token', name: 'dnspod_sk', type: 'text', maxlen: 34, size: 34, value: Apps.dnspod_sk },
{ title: '启动方式', name: 'dnspod_up', type: 'select', options:upoption_mode,value:Apps.dnspod_up || '2'},
{ title: '检查周期', name: 'dnspod_interval', type: 'text', maxlen: 5, size: 5, value: Apps.dnspod_interval || '5',suffix:'分钟(当启动方式为WAN UP时，此选项无效)'},
{ title: '域名', name: 'dnspod_domain', type: 'text', maxlen: 32, size: 34, value: Apps.dnspod_domain || 'ex.example.com'},
{ title: 'DNS服务器', name: 'dnspod_dns', type: 'text', maxlen: 15, size: 15, value: Apps.dnspod_dns ||'223.5.5.5',suffix:'<small>查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS</small>'},
{ title: '获取IP接口', name: 'dnspod_curl', type: 'select', options:option_mode,value:Apps.dnspod_curl || '1'},
//{ title: 'TTL', name: 'dnspod_ttl', type: 'text', maxlen: 5, size: 5, value: Apps.dnspod_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
