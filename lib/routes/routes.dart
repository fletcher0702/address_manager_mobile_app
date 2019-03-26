const HOST = 'http://68.183.78.0:3000';
Map<String,String> header = {"Content-Type": "application/json;charset=utf-8"};

// APP ROUTES
const LOGIN_ROUTE ='/login';
const SIGN_UP_ROUTE='signup';
const HOME_ROUTE = '/';
const ZONE_PANEL_ROUTE = '/zonepanel';
const TEAM_PANEL_ROUTE = '/teampanel';
const VISITS_PANEL_ROUTE = '/visitpanel';
const STATISTICS_PANEL_ROUTE = '/statisticspanel';

// HTTP ROUTES

// User Routes
const USER_BASE_URL = HOST+'/users/';
const LOGIN_HTTP_ROUTE = HOST +'/users/login';
const SIGN_UP_HTTP_ROUTE = HOST+ '/users/register';
const ALREADY_SIGNED_HTTP_ROUTE = HOST + '/users/checktoken';

// Zone Routes

const CREATE_ZONE_HTTP_ROUTE = HOST+'/users/teams/zones/create';
const UPDATE_ZONE_HTTP_ROUTE = HOST+'/users/teams/zones/update';
const DELETE_ZONE_HTTP_ROUTE = HOST+'/users/teams/zones/delete';

// Visit Routes

const CREATE_VISIT_HTTP_ROUTE = HOST+'/users/teams/zones/visits/create';
const UPDATE_VISIT_HTTP_ROUTE = HOST + '/users/teams/zones/visits/update';
const DELETE_VISIT_HTTP_ROUTE = HOST + '/users/teams/zones/visits/delete';

// Team Routes

const CREATE_TEAM_HTTP_ROUTE = HOST+'/users/teams/create';
const UPDATE_TEAM_HTTP_ROUTE = HOST+'/users/teams/update';
const DELETE_TEAM_HTTP_ROUTE = HOST+'/users/teams/delete';
const INVITE_USERS_TEAM_HTTP_ROUTE = HOST+'/users/teams/invite';

// Status Routes

const CREATE_TEAM_STATUS_HTTP_ROUTE = HOST + '/users/teams/status/create';
const UPDATE_TEAM_STATUS_HTTP_ROUTE = HOST + '/users/teams/status/update';
const DELETE_TEAM_STATUS_HTTP_ROUTE = HOST + '/users/teams/status/delete';
