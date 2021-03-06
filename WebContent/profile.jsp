<%@page import="com.gamestation.model.User"%>
<%@page import="com.gamestation.model.Game"%>
<%@page import="com.gamestation.service.IGameService"%>
<%@page import="com.gamestation.service.GameServiceImpl"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="java.util.ArrayList"%>

<jsp:include page="WEB-INF/views/header.jsp" />
<!DOCTYPE html>
<html>

<head>

<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

	User user = (User) session.getAttribute("currentSessionUser");
	String confirm = (String) request.getAttribute("confirmString");
	String confirmAddOrRem = (String) request.getAttribute("confirm");

	ArrayList<Game> gameList = new ArrayList<Game>();
	IGameService iGameService = new GameServiceImpl();

	if (user == null) {

		response.sendRedirect("login");
	}
%>

<%
	if (user != null) {
%>

<title><%=user.getUserName()%> | GameStation</title>

<%
	}
%>

<style>
</style>

</head>

<body
	onload="imageUploadAction('.photoCamera', '.profileImgFile', '.profileImage')">

	<div id="content" class="container gs-top">
		<div class="row">
			<!-- sidebar -->

			<div class="col-sm-12 col-md-4" id="profile-sidebar">

				<%
					if (user != null) {

						gameList = iGameService.getFav(user.getUserID());
				%>

				<div class="col-sm-12 pt-4" id="profile-details">
					<div class="picture pt-2">

						<img class="photoCamera profile-img over"
							src="images/photo-camera.png" width="150"
							style="height: 150px; width: 150px; display: none" />

						<%
							if (user.getImgDataBase64() != null) {
						%>

						<img class="profileImage profile-img under"
							src="data:image/PNG;base64,<%=user.getImgDataBase64()%>"
							width="150" style="height: 150px; width: 150px;" />

						<%
							} else {
						%>

						<img id="openProfileImgUpload" class="profile-img under"
							src="images/default.png" width="150"
							style="height: 150px; width: 150px;" />

						<%
							}
						%>

						<br /> <br />
						<h5><%=user.getUserName()%></h5>
						<form action="upload" method="POST" enctype="multipart/form-data">
							<input type="file" class="profileImgFile" name="image"
								accept="image/*" style="display: none" required />
							<button id="uploadBtn" class="btn btn-gs-red" type="submit"
								name="upload" value="Upload Image" style="display: none">Upload
								Image</button>
							<button class="resetBtn btn btn-gs-red" type="reset" name="reset"
								value="" style="display: none">Reset Image</button>
						</form>
						<hr>
					</div>

					<table style="width: 100%">
						<tr>
							<td align="left"><b>Name </td>
							<td align="right"><b><%=user.getFirstName() + " " + user.getLastName()%></td>
						</tr>
						<tr>
							<td align="left"><b>From</td>
							<td align="right"><b><%=user.getCountry()%></td>
						</tr>
						<tr>
							<td align="left"><b>Platform</td>
							<td align="right"><b><%=user.getPlatform()%></td>
						</tr>
						<tr>
							<td align="left"></td>
							<td align="right"><a href="settings">
									<button type="submit" class="btn btn-grey"
										style="margin-top: 5px; padding: 3px 5px 0 5px;">
										<i class="material-icons">&#xe3c9;</i>
									</button>
							</a></td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<%
									if (confirm != null) {
								%>
								<p style="color: green;" align="center">
									<br /><%=confirm%></p> <%
 	}
 %>
							</td>
						</tr>
					</table>
				</div>

				<div class="col-sm-12" id="profile-details">
					<span class="text-left"><b>About</b></span>
					<hr>

					<div id="profileAbout">
						<%
							if (user.getAbout() == null) {
						%>
						<p class="text-left">This paragraph contains a brief
							description about the user. Editable text.</p>
						<%
							} else {
						%>
						<p id="profile-about" class="text-left">
							<%=user.getAbout()%>
						</p>
						<%
							}
						%>
					</div>

					<form action="profile" method="POST">
						<div id="editAbout" class="form-group" style="display: none">

							<%-- <%
								if (user.getAbout() == null) {
							%>
							<textarea class="form-control" name="about" rows="4"
								placeholder="Enter your description here..." required></textarea>
							<%
								} else {
							%>
							<textarea class="form-control" name="about" rows="4"
								placeholder="Enter your description here..." required><%=user.getAbout()%></textarea>
							<%
								}
							%> --%>

							<textarea class="form-control" name="about" rows="4"
								placeholder="Enter your description here..." required></textarea>

						</div>

						<div class="text-right">
							<button id="confirmAbout" class="btn btn-gs-red mr-2"
								type="submit" name="upload" value="Confirm"
								style="display: none">Confirm</button>
							<button class="btn btn-grey" onclick="editProfileAbout()"
								style="padding: 3px 5px 0 5px;">
								<i class="material-icons">&#xe3c9;</i>
							</button>
						</div>
					</form>

				</div>

				<!-- <div class="col-sm-12" id="profile-details">another section</div> -->

				<%
					}
				%>

			</div>

			<!-- main content -->
			<div class="col-sm-12 col-md-8" id="profile-main">

				<div class="row">
					<div id="top-bar" class="col-sm-12 text-center">
						<h4>Favourites</h4>
					</div>

					<%
						if (confirmAddOrRem != null) {
					%>
					<div class="col-sm-12 text-center">
						<p align="center" style="color: green; text-align: center;"><%=confirmAddOrRem%></p>
					</div>
					<%
						}
					%>

					<%
						if (gameList.size() != 0) {
					%>

					<%
						for (Game favourite : gameList) {
					%>

					<div class="col-sm-12 col-md-6 col-lg-4">
						<div class="card text-center mb-4 pt-4">

							<%
								if (favourite.getImgDataBase64() != null && !favourite.getImgDataBase64().isEmpty()) {
							%>
							<a href="play-game?game-data=<%=favourite.getGameID()%>"
								style="color: black"> <img
								src="data:image/PNG;base64,<%=favourite.getImgDataBase64()%>"
								alt="<%=favourite.getGameName()%>"
								style="width: 100%; height: 150px; object-fit: cover;">
							</a>

							<%
								} else {
							%>
							<a href="play-game?game-data=<%=favourite.getGameID()%>"
								style="color: black"> <img src="images/game-default.png"
								alt="<%=favourite.getGameName()%>"
								style="width: 100%; height: 150px; object-fit: cover;">
							</a>
							<%
								}
							%>

							</a>
							<div class="card-container">
								<h6>
									<b><%=favourite.getGameName()%></b>
								</h6>
								<p>Game Category</p>

								<div class="d-inline">
									<form class="d-inline" method="GET" action="play">
										<input class="form-control" type="hidden" name="game"
											value="<%=favourite.getGameCode()%>">
										<button class="btn btn-gs-green w-45" type="submit">Play</button>
									</form>
								</div>
								<div class="d-inline">
									<form class="d-inline" method="POST" action="remove-fav">
										<input class="form-control" type="hidden" name="gameID"
											value="<%=favourite.getGameID()%>">
										<button class="btn btn-gs-red w-45" type="submit">Remove</button>
									</form>
								</div>

							</div>
						</div>
					</div>

					<%
						}
					%>

					<%
						} else {
					%>

					<div class="col text-center">

						<img class="img-responsive" src="images/error.png">
						<h4>
							Oops! Your list is empty. <br /> But it doesn't have to be.
						</h4>
						<h5 class="text-secondary mb-4">
							Join our play area now and add games to your favourites. <br />
							Keep Gaming!
						</h5>
						<a href="games">
							<button class="btn btn-gs-red">Play Now</button>
						</a>

					</div>

					<%
						}
					%>

				</div>

			</div>
		</div>
	</div>

	<script>
		
	</script>

	<jsp:include page="WEB-INF/views/footer.jsp" />

</body>

</html>