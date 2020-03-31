package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import java.util.List;
import java.util.Random;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import cn.nexgo.smartconnect.ISmartconnectService;
import cn.nexgo.smartconnect.listener.IInquireResultListener;
import cn.nexgo.smartconnect.listener.ISetupResultListener;
import cn.nexgo.smartconnect.listener.ITransactionRegisterListener;
import cn.nexgo.smartconnect.listener.ITransactionResultListener;
import cn.nexgo.smartconnect.model.InquireResultEntity;
import cn.nexgo.smartconnect.model.RegisterResultEntity;
import cn.nexgo.smartconnect.model.SetupParamsEntity;
import cn.nexgo.smartconnect.model.TransactionRequestEntity;
import cn.nexgo.smartconnect.model.TransactionResultEntity;
import cn.nexgo.smartconnect.model.data.Constant;

public class MainActivity extends AppCompatActivity {

    @BindView(R.id.btn_register)
    Button btnRegister;
    @BindView(R.id.btn_sale)
    Button btnSale;
    @BindView(R.id.btn_check)
    Button btnCheck;
    @BindView(R.id.btn_bind)
    Button btnBind;
    ISmartconnectService iSmartconnectService;
    @BindView(R.id.tv_result)
    TextView tvResult;
    @BindView(R.id.edt_amount)
    EditText edtAmount;
    @BindView(R.id.edt_transaction_id)
    EditText edtTransactionId;
    private static final String ACTION_BIND_SERVICE = "cn.nexgo.intent.action.SmartConnect";
    private static final String TAG = "MainActivity";
    @BindView(R.id.btn_unbind)
    Button btnUnbind;
    @BindView(R.id.rbtn_sale)
    RadioButton rbtnSale;
    @BindView(R.id.rbtn_void)
    RadioButton rbtnVoid;
    @BindView(R.id.rbtn_refund)
    RadioButton rbtnRefund;
    @BindView(R.id.rbtn_settlement)
    RadioButton rbtnSettlement;
    @BindView(R.id.rbtn_change_key)
    RadioButton rbtnChangeKey;
    @BindView(R.id.rgroup_trans_type)
    RadioGroup rgroupTransType;
    @BindView(R.id.btn_start_settings_page)
    Button btnStartSettingsPage;
    @BindView(R.id.btn_setup_params)
    Button btnSetupParams;
    @BindView(R.id.edt_transaction_number)
    EditText edtTranceNo;
    @BindView(R.id.edt_reference_number)
    EditText edtReferenceNo;
    private MyConnection myConnection;


    private int transType = Constant.TRANS_TYPE_SALE;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);
        init();
        bindService();
    }

    private void init() {
        //choose trans type
        rgroupTransType.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {

                    case R.id.rbtn_sale:
                        transType = Constant.TRANS_TYPE_SALE;
                        break;

                    case R.id.rbtn_void:
                        transType = Constant.TRANS_TYPE_VOID;
                        break;

                    case R.id.rbtn_refund:
                        transType = Constant.TRANS_TYPE_REFUND;
                        break;


                    case R.id.rbtn_settlement:
                        transType = Constant.TRANS_TYPE_SETTLEMENT;

                        break;

                    case R.id.rbtn_change_key:
                        transType = Constant.MODE_TMS_UPDATE;
                        break;


                    default:
                        transType = Constant.TRANS_TYPE_SALE;

                        break;

                }

            }
        });
    }

    //register result
    private ITransactionRegisterListener listener = new ITransactionRegisterListener.Stub() {
        @Override
        public void onRegisterResult(RegisterResultEntity registerResultEntity) throws RemoteException {
            Log.d(TAG, "onRegisterResult: getResultCode === " + registerResultEntity.getResultCode());
            Log.d(TAG, "onRegisterResult: getTrasacitonID ===" + registerResultEntity.getTransactionId());
            tvResult.setText("onRegisterResult: getResultCode === " + registerResultEntity.getResultCode() +
                    "\n" + "onRegisterResult: getTrasacitonID ===" + registerResultEntity.getTransactionId());
        }
    };

    //transaction result
    private ITransactionResultListener transactionResultListener = new ITransactionResultListener.Stub() {
        @Override
        public void onTransactionResult(TransactionResultEntity transactionResultEntity) throws RemoteException {

            Log.d(TAG, "onTransactionResult: getResult===" + transactionResultEntity.getResult());
            Log.d(TAG, "onTransactionResult:getCardNumber=== " + transactionResultEntity.getCardNumber());
            Log.d(TAG, "onTransactionResult:getAmount()=== " + transactionResultEntity.getAmount());
            tvResult.setText("onTransactionResult: getResult===" + transactionResultEntity.getResult() +
                    "\n" + "onTransactionResult:getResponseMessage()=== " + transactionResultEntity.getResponseMessage() +
                    "\n" + "onTransactionResult:getAmount()=== " + transactionResultEntity.getAmount() +
                    "\n" + "onTransactionResult:getCardNumber=== " + transactionResultEntity.getCardNumber());
        }
    };
    //inquire result
    private IInquireResultListener inquireResultListener = new IInquireResultListener.Stub() {
        @Override
        public void onInquireResult(InquireResultEntity inquireResultEntity) throws RemoteException {
            Log.d(TAG, "onInquireResult: getResult===" + inquireResultEntity.getResult());
            Log.d(TAG, "onInquireResult:getCardNumber ===" + inquireResultEntity.getCardNumber());
            Log.d(TAG, "onInquireResult:getAmount=== " + inquireResultEntity.getAmount());
            tvResult.setText("onInquireResult=== " + inquireResultEntity.getResult() +
                    "\n" + "onInquireResult:getResponseMessage=== " + inquireResultEntity.getResponseMessage() +
                    "\n" + "onInquireResult:getAmount=== " + inquireResultEntity.getAmount() +
                    "\n" + "onInquireResultget:CardNumber=== " + inquireResultEntity.getCardNumber());
        }
    };


    //setup result
    private ISetupResultListener setupResultListener = new ISetupResultListener.Stub() {
        @Override
        public void onSetupResult(int result) throws RemoteException {
            tvResult.setText("result code===" + result);
        }
    };

    @OnClick({R.id.btn_register, R.id.btn_sale, R.id.btn_check, R.id.btn_bind, R.id.btn_unbind, R.id.btn_start_settings_page, R.id.btn_setup_params})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.btn_bind:
                bindService();
                break;
            case R.id.btn_unbind:
                unbindService();
                break;
            case R.id.btn_register:
                register();
                break;
            case R.id.btn_sale:
                doTrans();
                break;
            case R.id.btn_check:
                check();
                break;
            case R.id.btn_start_settings_page:
                try {
                    iSmartconnectService.setup(Constant.MODE_SETUP_PAGE, null, setupResultListener);
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                break;

            case R.id.btn_setup_params:
                SetupParamsEntity setupParamsEntity = new SetupParamsEntity();
                //test params
                Random random = new Random();
                setupParamsEntity.setMerchantName("MerchantName" + random.nextInt(100));
                try {
                    iSmartconnectService.setup(Constant.MODE_SET_PARAMS, setupParamsEntity, setupResultListener);
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                break;
        }
    }

    //register
    public void register() {
        try {
            iSmartconnectService.transactionRegister(listener);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    //doTrans:start transaction
    private void doTrans() {
        //test data
        TransactionRequestEntity entity = new TransactionRequestEntity();
        entity.setTransacitonType(transType);
        entity.setAmount(edtAmount.getText().toString().trim());
        //        entity.setAmount("3");
        //void
        entity.setOriginTraceNum(edtTranceNo.getText().toString().trim());
        //refund
        entity.setOriginReferenceNum(edtReferenceNo.getText().toString().trim());
        entity.setOriginDate("0505");
        entity.setTrasanctionID(edtTransactionId.getText().toString().trim());

        Log.d(TAG, "doTrans: " + entity.getTransacitonType());
        if (entity==null) {
            Log.d(TAG, "doTrans:entity==null ");
            return;
        }

        try {
            iSmartconnectService.transactionRequest(entity, transactionResultListener);
        } catch (RemoteException e) {
            e.printStackTrace();
        }


    }

    //check transaction
    private void check() {
        try {
            iSmartconnectService.TransactionInquire(edtTransactionId.getText().toString().trim(), inquireResultListener);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }


    private void unbindService() {
        if (myConnection != null) {
            unbindService(myConnection);
        }
        tvResult.setText("bind service===" + false);
    }

    public boolean bindService() {
        Intent intent = new Intent();
        //bind the service
        intent.setPackage("cn.nexgo.rueco");
        intent.setAction(ACTION_BIND_SERVICE); //"cn.nexgo.intent.action.SmartConnect"
        final Intent eintent = new Intent(createExplicitFromImplicitIntent(this, intent));
        myConnection = new MyConnection();
        boolean b = bindService(eintent, myConnection, BIND_AUTO_CREATE);
        tvResult.setText("bind result===" + b);
        return b;
    }

    @Override
    protected void onDestroy() {
        unbindService();
        super.onDestroy();
    }

    class MyConnection implements ServiceConnection {

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            //iSmartconnectService = (IService) service;
            //必须使用IService中的静态方法转换，不能强转
            iSmartconnectService = ISmartconnectService.Stub.asInterface(service);
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            // TODO Auto-generated method stub
        }
    }

    /**
     * createExplicitFromImplicitIntent
     * 根据acton找到对应包名
     *
     * @param context
     * @param implicitIntent
     * @return
     */
    public static Intent createExplicitFromImplicitIntent(Context context, Intent implicitIntent) {
        // Retrieve all services that can match the given intent
        PackageManager pm = context.getPackageManager();
        List<ResolveInfo> resolveInfo = pm.queryIntentServices(implicitIntent, 0);
        Log.i("TTT", "resolveInfo=" + resolveInfo + "\n resolveInfo.size()=" + resolveInfo.size());
        // Make sure only one match was found
        if (resolveInfo == null || resolveInfo.size() != 1) {
            return new Intent();
        }

        // Get component info and create ComponentName
        ResolveInfo serviceInfo = resolveInfo.get(0);
        String packageName = serviceInfo.serviceInfo.packageName;
        String className = serviceInfo.serviceInfo.name;
        ComponentName component = new ComponentName(packageName, className);

        // Create a new intent. Use the old one for extras and such reuse
        Intent explicitIntent = new Intent(implicitIntent);
        // Set the component to be explicit
        explicitIntent.setComponent(component);

        return explicitIntent;
    }
}
