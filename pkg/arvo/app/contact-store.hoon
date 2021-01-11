:: contact-store [landscape]:
::
:: data store that holds individual contact data
::
/-  store=contact-store, *resource
/+  default-agent, dbug, *migrate
|%
+$  card  card:agent:gall
+$  state-4
  $:  %4
      =rolodex:store
      allowed-groups=(set resource)
      allowed-ships=(set ship)
  ==
+$  versioned-state
  $%  [%0 *]
      [%1 *]
      [%2 *]
      [%3 *]
      state-4
  ==
--
::
=|  state-4
=*  state  -
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init   on-init:def
++  on-save   !>(state)
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  ?+    -.old  [~ this]
    %4  [~ this(state old)]
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  |^
  =/  cards=(list card)
    ?+  path  (on-watch:def path)
      [%all ~]      (give [%initial rolodex])
      [%updates ~]  ~
    ==
  [cards this]
  ::
  ++  give
    |=  =update:store
    ^-  (list card)
    [%give %fact ~ [%contact-update !>(update)]]~
  --
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  |^
  =^  cards  state
    ?+  mark  (on-poke:def mark vase)
      %contact-update  (update !<(update:store vase))
      %import          (import q.vase)
    ==
  [cards this]
  ::
  ++  update
    |=  =update:store
    ^-  (quip card _state)
    |^
    ?-  -.update
      %initial   (handle-initial +.update)
      %add       (handle-add +.update)
      %remove    (handle-remove +.update)
      %edit      (handle-edit +.update)
      %allow     (handle-allow +.update)
      %disallow  (handle-disallow +.update)
    ==
    ::
    ++  handle-initial
      |=  rolo=rolodex:store
      ^-  (quip card _state)
      =.  rolodex  (~(uni by rolodex) rolo)
      :_  state(rolodex rolodex)
      (send-diff [%initial rolodex])
    ::
    ++  handle-add
      |=  [=ship =contact:store]
      ^-  (quip card _state)
      ?<  (~(has by rolodex) ship)
      :-  (send-diff [%add ship contact])
      state(rolodex (~(put by rolodex) ship contact))
    ::
    ++  handle-remove
      |=  =ship
      ^-  (quip card _state)
      ?>  (~(has by rolodex) ship)
      :-  (send-diff [%remove ship])
      state(rolodex (~(del by rolodex) ship))
    ::
    ++  handle-edit
      |=  [=ship =edit-field:store]
      |^
      ^-  (quip card _state)
      =/  contact  (~(got by rolodex) ship)
      =.  contact  (edit-contact contact edit-field)
      :-  (send-diff [%edit ship edit-field])
      state(rolodex (~(put by rolodex) ship contact))
      ::
      ++  edit-contact
        |=  [=contact:store edit=edit-field:store]
        ^-  contact:store
        ?-  -.edit
            %nickname  contact(nickname nickname.edit)
            %email     contact(email email.edit)
            %phone     contact(phone phone.edit)
            %website   contact(website website.edit)
            %color     contact(color color.edit)
            %avatar    contact(avatar avatar.edit)
        ==
      --
    ::
    ++  handle-allow
      |=  =beings:store
      ^-  (quip card _state)
      :-  (send-diff [%allow beings])
      ?-  -.beings
        %group  state(allowed-groups (~(put in allowed-groups) resource.beings))
        %ships  state(allowed-ships (~(uni in allowed-ships) ships.beings))
      ==
    ::
    ++  handle-disallow
      |=  =beings:store
      ^-  (quip card _state)
      :-  (send-diff [%disallow beings])
      ?-  -.beings
        %group  state(allowed-groups (~(del in allowed-groups) resource.beings))
        %ships  state(allowed-ships (~(dif in allowed-ships) ships.beings))
      ==
    ::
    ++  send-diff
      |=  =update:store
      ^-  (list card)
      [%give %fact ~[/updates] %contact-update !>(update)]~
    --
  ::
  ++  import
    |=  arc=*
    ^-  (quip card _state)
    ::  note: we are purposefully wiping all state before state-4
    [~ *state-4]
  --
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
    [%x %all ~]     ``noun+!>(rolodex)
  ::
      [%x %contact @ ~]
    =/  =ship  (slav %p i.t.t.path)
    =/  contact=(unit contact:store)  (~(get by rolodex) ship)
    ?~  contact  [~ ~]
    :-  ~  :-  ~  :-  %contact-update
    !>  ^-  update:store
    [%add ship u.contact]
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
