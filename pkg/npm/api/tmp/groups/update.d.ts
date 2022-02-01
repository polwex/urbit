import { PatpNoSig, Path, ShipRank, Enc } from '../lib';
import { roleTags } from './index';
export declare type RoleTags = typeof roleTags[number];
interface RoleTag {
    tag: 'admin' | 'moderator' | 'janitor';
}
interface AppTag {
    app: string;
    resource: string;
    tag: string;
}
export declare type Tag = AppTag | RoleTag;
export interface InvitePolicy {
    invite: {
        pending: Set<PatpNoSig>;
    };
}
export interface OpenPolicy {
    open: {
        banned: Set<PatpNoSig>;
        banRanks: Set<ShipRank>;
    };
}
export interface Resource {
    name: string;
    ship: PatpNoSig;
}
export declare type OpenPolicyDiff = AllowRanksDiff | BanRanksDiff | AllowShipsDiff | BanShipsDiff;
export interface AllowRanksDiff {
    allowRanks: ShipRank[];
}
export interface BanRanksDiff {
    banRanks: ShipRank[];
}
export interface AllowShipsDiff {
    allowShips: PatpNoSig[];
}
export interface BanShipsDiff {
    banShips: PatpNoSig[];
}
export declare type InvitePolicyDiff = AddInvitesDiff | RemoveInvitesDiff;
export interface AddInvitesDiff {
    addInvites: PatpNoSig[];
}
export interface RemoveInvitesDiff {
    removeInvites: PatpNoSig[];
}
export interface ReplacePolicyDiff {
    replace: GroupPolicy;
}
export declare type GroupPolicyDiff = {
    open: OpenPolicyDiff;
} | {
    invite: InvitePolicyDiff;
} | ReplacePolicyDiff;
export declare type GroupPolicy = OpenPolicy | InvitePolicy;
export interface TaggedShips {
    [tag: string]: Set<PatpNoSig>;
}
export interface Tags {
    role: TaggedShips;
    [app: string]: TaggedShips;
}
export interface Group {
    members: Set<PatpNoSig>;
    tags: Tags;
    policy: GroupPolicy;
    hidden: boolean;
}
export declare type Groups = {
    [p in Path]: Group;
};
export interface GroupUpdateInitial {
    initial: Enc<Groups>;
}
export interface GroupUpdateAddGroup {
    addGroup: {
        resource: Resource;
        policy: Enc<GroupPolicy>;
        hidden: boolean;
    };
}
export interface GroupUpdateAddMembers {
    addMembers: {
        ships: PatpNoSig[];
        resource: Resource;
    };
}
export interface GroupUpdateRemoveMembers {
    removeMembers: {
        ships: PatpNoSig[];
        resource: Resource;
    };
}
export interface GroupUpdateAddTag {
    addTag: {
        tag: Tag;
        resource: Resource;
        ships: PatpNoSig[];
    };
}
export interface GroupUpdateRemoveTag {
    removeTag: {
        tag: Tag;
        resource: Resource;
        ships: PatpNoSig[];
    };
}
export interface GroupUpdateChangePolicy {
    changePolicy: {
        resource: Resource;
        diff: GroupPolicyDiff;
    };
}
export interface GroupUpdateRemoveGroup {
    removeGroup: {
        resource: Resource;
    };
}
export interface GroupUpdateExpose {
    expose: {
        resource: Resource;
    };
}
export interface GroupUpdateInitialGroup {
    initialGroup: {
        resource: Resource;
        group: Enc<Group>;
    };
}
export declare type GroupUpdate = GroupUpdateInitial | GroupUpdateAddGroup | GroupUpdateAddMembers | GroupUpdateRemoveMembers | GroupUpdateAddTag | GroupUpdateRemoveTag | GroupUpdateChangePolicy | GroupUpdateRemoveGroup | GroupUpdateExpose | GroupUpdateInitialGroup;
export declare type GroupAction = Omit<GroupUpdate, 'initialGroup' | 'initial'>;
export {};
