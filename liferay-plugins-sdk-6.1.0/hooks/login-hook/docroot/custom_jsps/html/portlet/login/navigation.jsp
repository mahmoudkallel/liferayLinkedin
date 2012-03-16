<%--
/**
 * Copyright (c) 2012 Rotterdam CS, Inc. All rights reserved.
 
 * @author Rajesh
 */
--%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.linkedin.LinkedInUtil"%>
<%@ include file="/html/portlet/login/init.jsp" %>

<%
	String redirect = ParamUtil.getString(request, "redirect");
	boolean linkedInAuth = LinkedInUtil.isEnabled(company.getCompanyId());	 
%>

<portlet:actionURL var="linkedInAction" secure="true">
	<portlet:param name="struts_action" value="/login/linkedin_connect_oauth" />
	<portlet:param name="redirect" value="<%=redirect%>" />
</portlet:actionURL>

<script>
	// Once we have an authorization, pass back the token
	function onLinkedInAuth() {
		document.linkedinsubmit.submit();
	}
</script>

<form name="linkedinsubmit" action="<%=linkedInAction%>" method="post">
</form>
 
<%
String strutsAction = ParamUtil.getString(request, "struts_action");

boolean showAnonymousIcon = false;

if (!strutsAction.startsWith("/login/create_anonymous_account") && portletName.equals(PortletKeys.FAST_LOGIN)) {
	showAnonymousIcon = true;
}

boolean showCreateAccountIcon = false;

if (!strutsAction.equals("/login/create_account") && company.isStrangers() && !portletName.equals(PortletKeys.FAST_LOGIN)) {
	showCreateAccountIcon = true;
}

boolean showFacebookConnectIcon = false;

if (!strutsAction.startsWith("/login/facebook_connect") && FacebookConnectUtil.isEnabled(company.getCompanyId())) {
	showFacebookConnectIcon = true;
}

boolean showForgotPasswordIcon = false;

if (!strutsAction.equals("/login/forgot_password") && (company.isSendPassword() || company.isSendPasswordResetLink())) {
	showForgotPasswordIcon = true;
}

boolean showOpenIdIcon = false;

if (!strutsAction.equals("/login/open_id") && OpenIdUtil.isEnabled(company.getCompanyId())) {
	showOpenIdIcon = true;
}

boolean showSignInIcon = false;

if (Validator.isNotNull(strutsAction) && !strutsAction.equals("/login/login")) {
	showSignInIcon = true;
}
%>

<c:if test="<%= showAnonymousIcon || showCreateAccountIcon || showForgotPasswordIcon || showOpenIdIcon || showSignInIcon %>">
	<div class="navigation">
		
		<liferay-ui:icon-list>
			<c:if test="<%= linkedInAuth %>">
				<span>
					<script type="in/login" data-onAuth="onLinkedInAuth">
					Logging: <?js= firstName ?> <?js= lastName ?> ....
				</script>
				</span>
			</c:if>
			
			<c:if test="<%= showAnonymousIcon %>">
				<portlet:renderURL var="anonymousURL">
					<portlet:param name="struts_action" value="/login/create_anonymous_account" />
				</portlet:renderURL>

				<liferay-ui:icon
					message="guest"
					src='<%= themeDisplay.getPathThemeImages() + "/common/user_icon.png" %>'
					url="<%= anonymousURL %>"
				/>
			</c:if>

			<c:if test="<%= showSignInIcon %>">

				<%
				String signInURL = themeDisplay.getURLSignIn();

				if (portletName.equals(PortletKeys.FAST_LOGIN)) {
					signInURL = HttpUtil.addParameter(signInURL, "windowState", LiferayWindowState.POP_UP.toString());
				}
				%>

				<liferay-ui:icon
					image="status_online"
					message="sign-in"
					url="<%= signInURL %>"
				/>
			</c:if>

			<c:if test="<%= showFacebookConnectIcon %>">
				<portlet:renderURL var="loginRedirectURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
					<portlet:param name="struts_action" value="/login/login_redirect" />
				</portlet:renderURL>

				<%
				String facebookAuthRedirectURL = FacebookConnectUtil.getRedirectURL(themeDisplay.getCompanyId());
				facebookAuthRedirectURL = HttpUtil.addParameter(facebookAuthRedirectURL, "redirect", HttpUtil.encodeURL(loginRedirectURL.toString()));

				String facebookAuthURL = FacebookConnectUtil.getAuthURL(themeDisplay.getCompanyId());
				facebookAuthURL = HttpUtil.addParameter(facebookAuthURL, "client_id", FacebookConnectUtil.getAppId(themeDisplay.getCompanyId()));
				facebookAuthURL = HttpUtil.addParameter(facebookAuthURL, "redirect_uri", facebookAuthRedirectURL);
				facebookAuthURL = HttpUtil.addParameter(facebookAuthURL, "scope", "email");

				String taglibOpenFacebookConnectLoginWindow = "javascript:var facebookConnectLoginWindow = window.open('" + facebookAuthURL.toString() + "','facebook', 'align=center,directories=no,height=560,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000'); void(''); facebookConnectLoginWindow.focus();";
				%>

				<liferay-ui:icon
					image="../social_bookmarks/facebook"
					message="facebook"
					url="<%= taglibOpenFacebookConnectLoginWindow %>"
				/>
			</c:if>
			
			<c:if test="<%= showOpenIdIcon %>">
				<portlet:renderURL var="openIdURL">
					<portlet:param name="struts_action" value="/login/open_id" />
				</portlet:renderURL>

				<liferay-ui:icon
					message="open-id"
					src='<%= themeDisplay.getPathThemeImages() + "/common/openid.gif" %>'
					url="<%= openIdURL %>"
				/>
			</c:if>

			<c:if test="<%= showCreateAccountIcon %>">
				<liferay-ui:icon
					image="add_user"
					message="create-account"
					url="<%= PortalUtil.getCreateAccountURL(request, themeDisplay) %>"
				/>
			</c:if>

			<c:if test="<%= showForgotPasswordIcon %>">
				<portlet:renderURL var="forgotPasswordURL">
					<portlet:param name="struts_action" value="/login/forgot_password" />
				</portlet:renderURL>

				<liferay-ui:icon
					image="help"
					message="forgot-password"
					url="<%= forgotPasswordURL %>"
				/>
			</c:if>
		</liferay-ui:icon-list>
	</div>
</c:if>