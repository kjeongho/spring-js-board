<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<style type="text/css">
		.uploadResult {
			width: 100%;
			background-color: gray;
		}

		.uploadResult ul {
			display: flex;
			flex-flow: row;
			justify-content: center;
			align-items: center;
		} 
		
		.uploadResult ul li {
			list-style: none;
			padding: 10px;
		}
		
		.uploadResult ul li img {
			width: 100px;
		}
		</style>
		
		<style>
		.bigPictureWrapper {
		  position: absolute;
		  display: none;
		  justify-content: center;
		  align-items: center;
		  top:0%;
		  width:100%;
		  height:100%;
		  background-color: gray; 
		  z-index: 100;
		}
		
		.bigPicture {
		  position: relative;
		  display:flex;
		  justify-content: center;
		  align-items: center;
		}
	</style>
</head>
<body>
	<h1>Upload with Ajax</h1>
	
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<button id="uploadBtn">Upload</button>
	
	<div class="uploadResult">
		<ul></ul>
	</div>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div> 
	</div>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript">
		
	
		function showImage(fileCallPath){
			$(".bigPictureWrapper").css("display","flex").show();
			 
			$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>")
			  .animate({width:'100%', height: '100%'}, 1000); 
		} 
		
		$(".bigPictureWrapper").on("click", function(e) {
			$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
			
			setTimeout(() => {
				$(this).hide();	
			}, 1000); 	
		}); 
		
		 
		$(document).ready(function() {
			
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880; // 5MB
			
			function checkExtension(fileName, fileSize) {
				
				if(fileSize >= maxSize) {
					alert("?????? ????????? ??????");
					return false;
				}
				if(regex.test(fileName)) {
					alert("?????? ????????? ????????? ???????????? ??? ????????????.");
					return false;
				}
				
				return true;
			}
			
			var cloneObj = $(".uploadDiv").clone();
			   
			$("#uploadBtn").on("click", function() {
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files; 
				
				for(var i = 0; i < files.length; i++) {
					if(!checkExtension(files[i].name, files[i].size)) {
						return false;
					}
					
					formData.append("uploadFile", files[i]);
				}  
				 
				$.ajax({
					url : '/uploadAjaxAction',
					processData : false,
					contentType : false, 
					data : formData,
					type : 'POST',
					dataType : 'json',
					success : function(result) {
						
						showUploadedFile(result);
						$(".uploadDiv").html(cloneObj.html()); 
					}
				});
				
			});
			
			var uploadResult = $(".uploadResult ul");
			
			function showUploadedFile(uploadResultArr) {
				
				var str = "";
				
				$(uploadResultArr).each(function(i, obj) {
					
					if(!obj.image) {
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
						
						str += "<li>" +
									"<div>" +
										"<a href='/download?fileName="+fileCallPath+"'><img src='/resources/img/attach.phg'>"+obj.fileName+"</a>" +
										"<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>" + 
									"</div>" +
							   "</li>";
					} else { 
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
						
						var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
						originPath = originPath.replace(new RegExp(/\\/g), "/");
						
						str += "<li>" +  
									"<a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='display?fileName="+fileCallPath+"'></a>" +
									"<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>" +
							   "</li>";
					}
				});
				
				uploadResult.append(str);
			}
			
			$(".uploadResult").on("click", "span", function(e) {
				
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				
				$.ajax({
					url : '/deleteFile',
					data : {
						fileName : targetFile,
						type: type
					},
					dataType : 'text',
					type : 'POST',
					success : function(result) {
						alert(result);
					}
				}); 
			});
			 
		});
	</script>
</body>
</html>