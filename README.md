## [**Check your website for errors automatically using our Cloud SaaS for $9.99/month**](https://www.triplechecker.com)

# SiteInspector

![Version](https://img.shields.io/docker/v/siteinspector/siteinspector)
![Pulls](https://img.shields.io/docker/pulls/siteinspector/siteinspector)

[![Screenshot](https://www.getsiteinspector.com/packs/media/landing/images/si8-e5152df8eadeeabe91ef6f1d63170f9d.png)](https://www.getsiteinspector.com)

SiteInspector is a free, open-source tool that helps to find spelling errors, grammatical errors, and broken links on websites. It's written in Ruby/Rails with Vue.js front-end and uses a PostgreSQL database and Sidekiq with Redis to perform concurrent crawling.

Visit [getsiteinspector.com](https://www.getsiteinspector.com)

## Installation

### Docker

Install docker and docker-compose on your host machine and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/siteinspector/siteinspector/master/scripts/docker-install.sh)"
```

Open the app locally on port 808 ([http://localhost:808/](http://localhost:808/)) or using your remote server IP.

### Heroku

Deploy on Heroku using the button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Make sure that you have at least one worker dyno running - `heroku ps:scale worker=1 -a <app_name>`.

### Manually using docker-compose.yml

```bash
mkdir siteinspector && cd siteinspector

wget https://raw.githubusercontent.com/siteinspector/siteinspector/master/docker-compose.yml

docker-compose up
```

## API Documentation

### Setup
Set this to any hosts you want to be able to use. Only use hostnames, subdomains are automatically given request access.

docker-compose.yml:
```yml
    environment:
        ALLOWED_HOSTS: 'siteone.com,sitetwo.com'
```

### Authentication
SiteInspector wasn't built with a public API in mind. But you can fetch a token by getting the csrf token and then logging in with your credentials and getting the cookies. Then you can make CRUD requests to the SiteInspector backend from domains you set above. You can automate this in code. Here's an example in PHP of a function that makes a request to siteinspector to and returns the cookies to use to authenticate later requests:

```php
function login($config)
{
    $baseUrl = $config['base_url'];
    $email = $config['email'];
    $password = $config['password'];

    // First, make a GET request to the login page to get the CSRF token
    $curl = curl_init($baseUrl . '/sign_in');
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($curl);
    curl_close($curl);

    // Extract the CSRF token from the HTML content
    preg_match('/<meta[^>]*(?:name="csrf-token"[^>]*content="([^"]+)"|content="([^"]+)"[^>]*name="csrf-token")[^>]*>/', $response, $matches);
    $csrfToken = $matches[1] ?? $matches[2] ?? null;

    if (!$csrfToken) {
        throw new \Exception('Failed to retrieve CSRF token');
    }

    // Now, make the POST request to log in, including the CSRF token
    $curl = curl_init($baseUrl . '/sign_in');
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query([
        'authenticity_token' => $csrfToken,
        'user[email]' => $email,
        'user[password]' => $password,
    ]));
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($curl);
    curl_close($curl);

    if ($response === false) {
        throw new \Exception('Login failed');
    }

    // Check if the login was successful (you may need to adjust the condition based on the response)
    if (strpos($response, 'Login successful') === false) {
        throw new \Exception('Login failed: ' . $response);
    }

    // Extract cookies from the response headers
    preg_match_all('/^Set-Cookie:\s*([^;\r\n]*)/mi', $response, $cookieMatches);
    $cookies = array();
    foreach ($cookieMatches[1] as $cookie) {
        parse_str($cookie, $cookieData);
        $cookies = array_merge($cookies, $cookieData);
    }

    return $cookies;
}
```

### Endpoints
1. `/api/websites/:website_id/active_crawl_session` (HTTP GET)
    - Controller: `Api::ActiveCrawlSessionsController`
    - Action: `show`
    - Description: Retrieves the active crawl session for a specific website.
    - Parameters: `website_id` (in URL)
    - Response: JSON representation of the active crawl session.
2. `/api/crawl_sessions/:crawl_session_id/cancel` (HTTP POST)
    - Controller: `Api::CrawlSessionsCancelController`
    - Action: `create`
    - Description: Cancels a specific crawl session.
    - Parameters: `crawl_session_id` (in URL)
    - Response: JSON representation of the canceled crawl session or an error.
3. `/api/websites/:website_id/crawl_sessions` (HTTP GET)
    - Controller: `Api::CrawlSessionsController`
    - Action: `index`
    - Description: Retrieves a list of crawl sessions for a specific website, limited to 50.
    - Parameters: `website_id` (in URL)
    - Response: JSON representation of the list of crawl sessions.
4. `/api/websites/:website_id/crawl_sessions` (HTTP POST)
    - Controller: `Api::CrawlSessionsController`
    - Action: `create`
    - Description: Creates a new crawl session for a specific website.
    - Parameters: `website_id` (in URL)
    - Response: JSON representation of the created crawl session or an error.
5. `/api/crawl_sessions/:crawl_session_id` (HTTP PATCH/PUT)
    - Controller: `Api::CrawlSessionsController`
    - Action: `update`
    - Description: Updates a specific crawl session.
    - Parameters: `crawl_session_id` (in URL), `status` (in request body)
    - Response: JSON representation of the updated crawl session or an error.
6. `/api/websites/:website_id/custom_rules` (HTTP GET)
    - Controller: `Api::CustomRulesController`
    - Action: `index`
    - Description: Retrieves a list of custom rules for a specific website.
    - Parameters: `website_id` (in URL)
    - Response: JSON representation of the list of custom rules.
7. `/api/custom_rules/:custom_rule_id` (HTTP GET)
    - Controller: `Api::CustomRulesController`
    - Action: `show`
    - Description: Retrieves a specific custom rule.
    - Parameters: `custom_rule_id` (in URL)
    - Response: JSON representation of the custom rule.
8. `/api/websites/:website_id/custom_rules` (HTTP POST)
    - Controller: `Api::CustomRulesController`
    - Action: `create`
    - Description: Creates a new custom rule for a specific website.
    - Parameters: `website_id` (in URL), `pattern`, `condition`, `paths` (in request body)
    - Response: JSON representation of the created custom rule or an error.
9. `/api/custom_rules/:custom_rule_id` (HTTP PATCH/PUT)
    - Controller: `Api::CustomRulesController`
    - Action: `update`
    - Description: Updates a specific custom rule.
    - Parameters: `custom_rule_id` (in URL), `pattern`, `condition`, `paths` (in request body)
    - Response: JSON representation of the updated custom rule or an error.
10. `/api/custom_rules/:custom_rule_id` (HTTP DELETE)
    - Controller: `Api::CustomRulesController`
    - Action:`destroy`
    - Description: Deletes a specific custom rule.
    - Parameters: `custom_rule_id` (in URL)
    - Response: HTTP status code indicating success or failure.
11. `/api/websites/:website_id/report_shareable_link` (HTTP GET)
    - Controller: `Api::ReportShareableLinksController`
    - Action: `show`
    - Description: Retrieves the shareable links for the report of a specific website.
    - Parameters: `website_id` (in URL)
    - Response: JSON representation of the shareable links (viewer and editor).
12. `/api/websites/:website_id/report` (HTTP GET)
    - Controller: `Api::ReportsController`
    - Action: `show`
    - Description: Retrieves the report for a specific website.
    - Parameters: `website_id` (in URL)
    - Response: JSON representation of the website report.
13. `/api/session` (HTTP DELETE)
    - Controller: `Api::SessionsController`
    - Action: `destroy`
    - Description: Signs out the current user.
    - Parameters: None
    - Response: HTTP status code indicating success.
14. `/api/setup` (HTTP POST)
    - Controller: `Api::SetupsController`
    - Action: `create`
    - Description: Creates the initial setup if no users exist.
    - Parameters: `first_name`, `last_name`, `email`, `password` (in request body)
    - Response: JSON representation of the user or an error.
15. `/api/users` (HTTP GET)
    - Controller: `Api::UsersController`
    - Action: `index`
    - Description: Retrieves a list of users.
    - Parameters: None
    - Response: JSON representation of the list of users.
16. `/api/users/:user_id` (HTTP GET)
    - Controller: `Api::UsersController`
    - Action: `show`
    - Description: Retrieves a specific user.
    - Parameters: `user_id` (in URL)
    - Response: JSON representation of the user.
17. `/api/users` (HTTP POST)
    - Controller: `Api::UsersController`
    - Action: `create`
    - Description: Creates a new user.
    - Parameters: `email`, `first_name`, `last_name`, `password` (in request body)
    - Response: JSON representation of the created user or an error.
18. `/api/users/:user_id` (HTTP PATCH/PUT)
    - Controller: `Api::UsersController`
    - Action: `update`
    - Description: Updates a specific user.
    - Parameters: `user_id` (in URL), `email`, `first_name`, `last_name`, `password` (in request body)
    - Response: JSON representation of the updated user or an error.
19. `/api/users/:user_id` (HTTP DELETE)
    - Controller: `Api::UsersController`
    - Action: `destroy`
    - Description: Deletes a specific user.
    - Parameters: `user_id` (in URL)
    - Response: HTTP status code indicating success.
20. `/api/website_page_errors/:website_page_error_id` (HTTP PATCH/PUT)
    - Controller: `Api::WebsitePageErrorsController`
    - Action: `update`
    - Description: Updates a specific website page error.
    - Parameters: `website_page_error_id` (in URL), `status` (in request body)
    - Response: JSON representation of the updated website page error or an error.
21. `/api/website_page_errors/:website_page_error_id/mark_false_positive` (HTTP POST)
    - Controller: `Api::WebsitePageErrorsMarkFalsePositiveController` -Action: `create`
    - Description: Marks a specific website page error as a false positive.
    - Parameters: `website_page_error_id` (in URL), `permanent` (in request body, optional)
    - Response: HTTP status code indicating success.
22. `/api/website_page_website_resources/:website_page_website_resource_id` (HTTP PATCH/PUT)
    - Controller: `Api::WebsitePageWebsiteResourcesController`
    - Action: `update`
    - Description: Updates a specific website page website resource.
    - Parameters: `website_page_website_resource_id` (in URL), `is_resolved` (in request body)
    - Response: JSON representation of the updated website page website resource or an error.
23. `/api/website_resources/:website_resource_id` (HTTP PATCH/PUT)
    - Controller: `Api::WebsiteResourcesController`
    - Action: `update`
    - Description: Updates a specific website resource.
    - Parameters: `website_resource_id` (in URL), `status` (in request body)
    - Response: JSON representation of the updated website resource or an error.
24. `/api/websites` (HTTP GET)
    - Controller: `Api::WebsitesController`
    - Action: `index`
    - Description: Retrieves a list of enabled websites ordered by domain.
    - Parameters: None
    - Response: JSON representation of the list of websites.
25. `/api/websites/:website_id` (HTTP GET)
    - Controller: `Api::WebsitesController`
    - Action: `show`
    - Description: Retrieves a specific website.
    - Parameters: `website_id` (in URL)
    - Response: JSON representation of the website.
26. `/api/websites` (HTTP POST)
    - Controller: `Api::WebsitesController`
    - Action: `create`
    - Description: Creates or finds a website for a specific domain and updates its preferences and custom rules.
    - Parameters: `domain`, `preferences` (in request body)
    - Response: JSON representation of the website.
27. `/api/websites/:website_id` (HTTP PATCH/PUT)
    - Controller: `Api::WebsitesController`
    - Action: `update`
    - Description: Updates a specific website.
    - Parameters: `website_id` (in URL), `domain`, `preferences` (in request body)
    - Response: JSON representation of the updated website or an error.
28. `/api/websites/:website_id` (HTTP DELETE)
    - Controller: `Api::WebsitesController`
    - Action: `destroy`
    - Description: Disables a specific website.
    - Parameters: `website_id` (in URL)
    - Response: JSON representation of the disabled website.

## License

SiteInspector is licensed under the AGPL v3 license.
