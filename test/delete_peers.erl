%%%-------------------------------------------------------------------
%%% @author ashirko
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Окт. 2019 15:57
%%%-------------------------------------------------------------------
-module(delete_peers).
-author("ashirko").

-include_lib("eunit/include/eunit.hrl").

delete_peers_test() ->
    PeerID1 = {test_delete1, node()},
    PeerID2 = {test_delete2, node()},
    PeerID3 = {test_delete3, node()},
    Peers = [PeerID1, PeerID2, PeerID3],
    %%  check that peers do not exist before creation
    lists:foreach(fun(P) ->
        ?assertEqual(ok,zraft_client:check_exists(P))
                  end, Peers),
    {ok, _} = zraft_lib_sup:start_link(),
    ?assertEqual({ok, Peers}, zraft_client:create(Peers,zraft_dict_backend)),
    %%  check that peers were created successfully
    lists:foreach(fun(P) ->
        ?assertEqual({error, already_present},zraft_client:check_exists(P))
                  end, Peers),
    ok = zraft_client:delete(Peers),
    %%  check that peers were deleted successfully
    lists:foreach(fun(P) ->
        ?assertEqual(ok,zraft_client:check_exists(P))
                  end, Peers).

