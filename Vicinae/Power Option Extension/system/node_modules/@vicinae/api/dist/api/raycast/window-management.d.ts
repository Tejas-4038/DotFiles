import { RaycastApplication } from './system';
type RaycastWindow = {
    active: boolean;
    bounds: {
        position: {
            x: number;
            y: number;
        };
        size: {
            height: number;
            width: number;
        };
    } | "fullscreen";
    desktopId: string;
    fullScreenSettable: boolean;
    id: string;
    positionable: boolean;
    resizable: boolean;
    application?: RaycastApplication;
};
declare enum DesktopType {
    User = 0,
    FullScreen = 1
}
type RaycastDesktop = {
    id: string;
    screenId: string;
    size: {
        height: number;
        width: number;
    };
    active: boolean;
    type: DesktopType;
};
declare class RaycastWindowManagement {
    getActiveWindow(): Promise<RaycastWindow>;
    getDesktops(): Promise<RaycastDesktop[]>;
    getWindowsOnActiveDesktop(): Promise<RaycastWindow[]>;
    constructor();
}
export declare const WindowManagement: RaycastWindowManagement;
export {};
