const HOST = 'http://10.0.2.2:3000';
final header = {"Content-Type": "application/json;charset=utf-8"};

// APP ROUTES
const LOGIN_ROUTE ='/login';
const SIGN_UP_ROUTE='signup';
const HOME_ROUTE = '/';
const ZONE_PANEL_ROUTE = '/zonepanel';
const TEAM_PANEL_ROUTE = '/teampanel';
const VISITS_PANEL_ROUTE = '/visitpanel';

// HTTP ROUTES

// User Routes
const USER_BASE_URL = HOST+'/users/';
const LOGIN_HTTP_ROUTE = HOST +'/users/login';
const SIGN_UP_HTTP_ROUTE = HOST+ '/users/register';
const ALREADY_SIGNED_HTTP_ROUTE = HOST + '/users/checktoken';

// Zone Routes

const CREATE_ZONE_HTTP_ROUTE = HOST+'/zones/create';

// Visit Routes

const CREATE_VISIT_HTTP_ROUTE = HOST+'/users/teams/visits/create';

// Team Routes

const CREATE_TEAM_HTTP_ROUTE = HOST+'/users/teams/create';

// Status Routes

const CREATE_TEAM_STATUS_HTTP_ROUTE = HOST + '/users/teams/status/create';