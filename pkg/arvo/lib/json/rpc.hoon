::  json-rpc: protocol utilities
::
/-  *json-rpc
|%
++  request-to-hiss
  |=  [url=purl:eyre req=request]
  ^-  hiss:eyre
  :-  url
  :+  %post
    %-  ~(gas in *math:eyre)
    ~['Content-Type'^['application/json']~]
  %-  some
  %-  as-octt:mimes:html
  (en-json:html (request-to-json req))
::
++  request-to-json
  |=  request
  ^-  json
  %-  pairs:enjs:format
  :~  jsonrpc+s+'0.2'
      id+s+id
      method+s+method
    ::
      :-  %params
      ^-  json
      ?-  -.params
        %list    [%a +.params]
        ::  FIXME: support either %map or %object (also in /sur/json/rpc)
        ::
        %map     [%o +.params]
        %object  [%o (~(gas by *(map @t json)) +.params)]
  ==  ==
::
++  response-to-json
  |=  =response
  ^-  json
  ::  TODO: consider all cases
  ::
  ?+  -.response  ~|([%unsupported-rpc-response response] !!)
      %result
    :-  %o
    %-  molt
    ^-  (list [@t json])
    ::  FIXME: return 'id' as string, number or NULL
    ::
    :~  ['jsonrpc' s+'2.0']
        ['id' s+id.response]
        ['result' res.response]
    ==
  ::
      %error
    :-  %o
    %-  molt
    ^-  (list [@t json])
    :~  ['jsonrpc' s+'2.0']
        ['id' ?~(id.response ~ s+id.response)]
        ['code' n+code.response]
        ['message' s+message.response]
    ==
  ==
::
++  validate-request
  |=  [body=(unit octs) parse-method=$-(@t term)]
  ^-  (unit request)
  ?~  body  ~
  ?~  jon=(de-json:html q.u.body)  ~
  ::  ignores non-object responses
  ::
  :: ?.  ?=([%o *] json)  ~|([%format-not-valid json] !!)
  ?.  ?=([%o *] u.jon)  ~
  %-  some
  %.  u.jon
  =,  dejs:format
  ::  TODO: If parsing fails, return a proper error (not 500)
  ::
  %-  ot
  :~  ::  FIXME: parse 'id' as string, number or NULL
      ::
      ['id' so]
      ['jsonrpc' (su (jest '2.0'))]
      ['method' (cu parse-method so)]
    ::
      :-  'params'
      |=  =json
      ^-  request-params
      ?+  -.json  !!
        %a  [%list ((ar same) json)]
        %o  [%map ((om same) json)]
  ==  ==
::
++  error
  |_  id=@t
  ::  https://www.jsonrpc.org/specification#error_object
  ::
  ++  parse      [%error id '-32700' 'Failed to parsed']
  ++  request    [%error id '-32600' 'Invalid Request']
  ++  method     [%error id '-32601' 'Method not found']
  ++  params     [%error id '-32602' 'Invalid params']
  ++  internal   [%error id '-32603' 'Internal error']
  ++  not-found  [%error id '-32000' 'Resource not found']
  --
--
