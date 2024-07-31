# Keycloak Login Setup

## Create Social Login Key
1. Press Ctrl + G and search for `Social Login Key List`
2. Click on `+ Add Social Login Key` button on top right
3. Refer to the following config for settings

```
{
    "name": "Keycloak",
    "enable_social_login": 1,
    "social_login_provider": "Custom",
    "client_id": "login_client",
    "provider_name": "keycloak",
    "client_secret": "abcd", // Can be any random string
    "icon": "",
    "base_url": "https://auth.kalvium.community/auth/realms/kalvium-dev",
    "sign_ups": "Allow",
    "authorize_url": "/protocol/openid-connect/auth",
    "access_token_url": "/protocol/openid-connect/token",
    "redirect_url": "https://dev-krp.kalvium.org/api/method/frappe.integrations.oauth2_logins.custom/keycloak",
    "api_endpoint": "https://auth.kalvium.community/auth/realms/kalvium-dev/protocol/openid-connect/userinfo",
    "custom_base_url": 1,
    "api_endpoint_args": "",
    "auth_url_data": "{"response_type": "code", "scope": "openid profile email"}",
    "user_id_property": "preferred_username",
}
```


## Notes
- Add the base url of app to `Valid redirect URIs` in client of keycloak